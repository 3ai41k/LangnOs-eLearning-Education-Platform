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

protocol SectionViewModelProtocol: class {
    var cells: [CellViewModelProtocol] { get set }
    var reload: AnyPublisher<Void, Never> { get }
}

protocol UniversalTableSectionViewModelProtocol: SectionViewModelProtocol {
    
}

protocol UniversalTableViewSectionProtocol {
    var tableSections: [UniversalTableSectionViewModelProtocol] { get }
}

protocol UniversalTableViewOutputProtocol {
    func didSelectCellAt(indexPath: IndexPath)
}

extension UniversalTableViewOutputProtocol {
    func didSelectCellAt(indexPath: IndexPath) { }
}

protocol CellResizableProtocol where Self: UITableViewCell {
    var beginUpdate: (() -> Void)? { get set }
    var endUpdate: (() -> Void)? { get set }
}

final class UniversalTableView: UITableView {
    
    // MARK: - Public properties
    
    var viewModel: UniversalTableViewModelProtocol? {
        didSet {
            viewModel?.tableSections.enumerated().forEach({ (index, section) in
                section.reload.sink(receiveValue: { [weak self] in
                    self?.reloadSections([index], with: .fade)
                }).store(in: &cancellable)
            })
        }
    }
    var cellFactory: UniversalTableViewCellFactoryProtocol? {
        didSet {
            cellFactory?.registerAllCells(tableView: self)
        }
    }
    
    // MARK: - Private properties
    
    private var cancellable: [AnyCancellable] = []
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initializeComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initializeComponents()
    }
    
    deinit {
        removeNotifications()
    }
    
    // MARK: - Public methods
    
    func start() {
        self.dataSource = self
        self.delegate = self
        
        self.reloadData()
    }
    
    // MARK: - Private methods
    
    private func initializeComponents() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc
    private func keyboardWillShow(_ notificatio: Notification) {
        guard let keyboardSize = notificatio.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.cgRectValue.height + 50.0, right: 0)
    }
    
    @objc
    private func keyboardWillHide() {
        contentInset = .zero
    }
    
}

// MARK: - UITableViewDataSource

extension UniversalTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.tableSections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.tableSections[section].cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cellViewModel = viewModel?.tableSections[indexPath.section].cells[indexPath.row],
            let cell = cellFactory?.generateCell(cellViewModel: cellViewModel, tableView: tableView, indexPath: indexPath)
        else {
            return UITableViewCell()
        }
        
        if let cell = cell as? CellResizableProtocol {
            cell.beginUpdate = {
                tableView.beginUpdates()
            }
            cell.endUpdate = {
                tableView.endUpdates()
            }
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension UniversalTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectCellAt(indexPath: indexPath)
    }
    
}


