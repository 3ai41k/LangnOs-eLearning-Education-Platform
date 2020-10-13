//
//  FixedTableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

typealias UniversalCollectionViewViewModel =
    UniversalCollectionViewSectionProtocol &
    UniversalCollectionViewOutputProtocol

protocol CollectionReusableViewModelProtocol {
    
}

protocol CollectionSectionViewModelProtocol: SectionViewModelProtocol {
    var sectionViewModel: CollectionReusableViewModelProtocol? { get }
}

protocol UniversalCollectionViewSectionProtocol {
    var tableSections: [CollectionSectionViewModelProtocol] { get }
}

protocol UniversalCollectionViewOutputProtocol {
    func didSelectCellAt(indexPath: IndexPath)
    func refreshData(completion: @escaping () -> Void)
}

extension UniversalCollectionViewOutputProtocol {
    func didSelectCellAt(indexPath: IndexPath) { }
    func refreshData(completion: @escaping () -> Void) { }
}

protocol UniversalCollectionViewSectionFactoryProtocol {
    func registerAllViews(collectionView: UICollectionView)
    func generateView(sectionViewModel: CollectionReusableViewModelProtocol,
                      collectionView: UICollectionView,
                      indexPath: IndexPath) -> UICollectionReusableView
}

final class UniversalCollectionView: UICollectionView {
    
    // MARK: - Public properties
    
    var viewModel: UniversalCollectionViewViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    var cellFactory: UniversalCollectionViewCellFactoryProtocol? {
        didSet {
            cellFactory?.registerAllCells(collectionView: self)
        }
    }
    
    var sectionFactory: UniversalCollectionViewSectionFactoryProtocol? {
        didSet {
            sectionFactory?.registerAllViews(collectionView: self)
        }
    }
    
    var layout: UniversalCollectionViewLayoutProtocol? {
        didSet {
            guard let collectionViewLayout = layout?.collectionViewLayout else { return }
            self.collectionViewLayout = collectionViewLayout
        }
    }
    
    var customBackgroundView: UIView?
    
    // MARK: - Private properties
    
    private var cancellable: [AnyCancellable] = []
    
    // MARK: - Public methods
    
    func start() {
        self.dataSource = self
        self.delegate = self
        
        self.reloadData()
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addRefreshControl()
        //addTapGesture()
    }
    
    override func reloadData() {
        super.reloadData()
        
        setBackgroundViewIfSectionsAreEmpty()
    }
    
    override func reloadSections(_ sections: IndexSet) {
        super.reloadSections(sections)
        
        setBackgroundViewIfSectionsAreEmpty()
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel?.tableSections.enumerated().forEach({ (index, section) in
            section.reload.sink(receiveValue: { [weak self] in
                self?.reloadSections(IndexSet(integer: index))
            }).store(in: &cancellable)
        })
    }
    
    private func setBackgroundViewIfSectionsAreEmpty() {
        if let sections = viewModel?.tableSections {
            var emptySections: [Bool] = []
            for section in sections {
                if section.cells.isEmpty {
                    emptySections.append(true)
                }
            }
            if emptySections.contains(false) {
                backgroundView = nil
            } else {
                backgroundView = customBackgroundView
            }
        }
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didEndEditing))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        viewModel?.refreshData {
            sender.endRefreshing()
        }
    }
    
    @objc
    private func didEndEditing() {
        self.endEditing(true)
    }
    
}

// MARK: - UICollectionViewDataSource

extension UniversalCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.tableSections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.tableSections[section].cells.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cellViewModel = viewModel?.tableSections[indexPath.section].cells[indexPath.row],
            let cell = cellFactory?.generateCell(cellViewModel: cellViewModel, collectionView: collectionView, indexPath: indexPath)
        else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension UniversalCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectCellAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            let sectionViewModel = viewModel?.tableSections[indexPath.section].sectionViewModel,
            let rusableView = sectionFactory?.generateView(sectionViewModel: sectionViewModel, collectionView: collectionView, indexPath: indexPath)
        else {
            return UICollectionReusableView()
        }
        return rusableView
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UniversalCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        layout?.sizeForItemAt(collectionView, indexPath: indexPath) ?? CGSize(width: 0.0, height: 0.0)
    }
    
}
