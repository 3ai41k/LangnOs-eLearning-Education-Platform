//
//  UniversalTableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

typealias UniversalTableViewModelProtocol =
    UniversalTableViewSectionProtocol &
    UniversalTableViewOutputProtocol

protocol SectionViewFactoryProtocol {
    func generateView(sectionViewModel: SectionViewViewModelProtocol) -> UIView
}

protocol SectionViewViewModelProtocol {
    
}

protocol SectionViewModelProtocol {
    var cells: CurrentValueSubject<[CellViewModelProtocol], Never> { get }
    var sectionHeaderViewModel: SectionViewViewModelProtocol? { get }
    var sectionFooterViewModel: SectionViewViewModelProtocol? { get }
}

protocol UniversalTableViewSectionProtocol {
    var tableSections: [SectionViewModelProtocol] { get }
}

protocol UniversalTableViewOutputProtocol {
    func didSelectCellAt(indexPath: IndexPath)
    func deleteItemForRowAt(indexPath: IndexPath)
}

extension UniversalTableViewOutputProtocol {
    func didSelectCellAt(indexPath: IndexPath) { }
    func deleteItemForRowAt(indexPath: IndexPath) { }
}

protocol CellResizableProtocol where Self: UITableViewCell {
    var beginUpdate: (() -> Void)? { get set }
    var endUpdate: (() -> Void)? { get set }
}

final class UniversalTableView: UITableView {
    
    // MARK: - Public properties
    
    var animated = false
    
    var viewModel: UniversalTableViewModelProtocol? {
        didSet {
            viewModel?.tableSections.enumerated().forEach({ index, section in
                section.cells.sink(receiveValue: { [weak self] _ in
                    if self?.animated == true {
                        self?.reloadSections([index], with: .automatic)
                    } else {
                        UIView.performWithoutAnimation {
                            self?.reloadSections([index], with: .none)
                        }
                    }
                }).store(in: &cancellable)
            })
        }
    }
    var cellFactory: UniversalTableViewCellFactoryProtocol? {
        didSet {
            cellFactory?.registerAllCells(tableView: self)
        }
    }
    var sectionFactory: SectionViewFactoryProtocol?
    
    // MARK: - Private properties
    
    private var cancellable: [AnyCancellable] = []
    
    // MARK: - Override
    
    override func reloadData() {
        super.reloadData()
        
        hideBackgroundViewIfSectionsAreEmpty()
    }
    
    override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        super.reloadSections(sections, with: animation)
        
        hideBackgroundViewIfSectionsAreEmpty()
    }
    
    // MARK: - Public methods
    
    func start() {
        self.dataSource = self
        self.delegate = self
        
        self.reloadData()
    }
    
    // MARK: - Private methods
    
    private func hideBackgroundViewIfSectionsAreEmpty() {
        if let sections = viewModel?.tableSections {
            if sections.map({ $0.cells.value.isEmpty }).contains(false) {
                backgroundView?.isHidden = true
            } else {
                backgroundView?.isHidden = false
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension UniversalTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.tableSections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.tableSections[section].cells.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cellViewModel = viewModel?.tableSections[indexPath.section].cells.value[indexPath.row],
            let cell = cellFactory?.generateCell(cellViewModel: cellViewModel, tableView: tableView, indexPath: indexPath)
        else {
            return UITableViewCell()
        }
        
        if let cell = cell as? CellResizableProtocol {
            cell.beginUpdate = { [weak self] in
                self?.beginUpdates()
            }
            cell.endUpdate = { [weak self] in
                self?.endUpdates()
            }
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension UniversalTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectCellAt(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let hederViewModel = viewModel?.tableSections[section].sectionHeaderViewModel else { return nil }
        return sectionFactory?.generateView(sectionViewModel: hederViewModel)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerViewModel = viewModel?.tableSections[section].sectionFooterViewModel else { return nil }
        return sectionFactory?.generateView(sectionViewModel: footerViewModel)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        tableView.isEditing ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteItemForRowAt(indexPath: indexPath)
        }
    }
    
}


