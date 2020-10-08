//
//  FixedTableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

typealias UniversalCollectionViewViewModel = UniversalCollectionViewSectionProtocol & UniversalCollectionViewOutputProtocol

protocol CollectionReusableViewModelProtocol {
    
}

protocol CollectionSectionViewModelProtocol: SectionViewModelProtocol {
    var sectionViewModel: CollectionReusableViewModelProtocol? { get }
}

protocol UniversalCollectionViewSectionProtocol {
    var tableSections: [CollectionSectionViewModelProtocol] { get }
}

protocol UniversalCollectionViewSectionFactoryProtocol {
    func registerAllViews(collectionView: UICollectionView)
    func generateView(sectionViewModel: CollectionReusableViewModelProtocol,
                      collectionView: UICollectionView,
                      indexPath: IndexPath) -> UICollectionReusableView
}

final class UniversalCollectionView: UICollectionView {
    
    // MARK: - Private properties
    
    private var cancellable: [AnyCancellable] = []
    
    private var viewModel: UniversalCollectionViewViewModel! {
        didSet {
            bindViewModel()
        }
    }
    private var cellFactory: UniversalCollectionViewCellFactoryProtocol! {
        didSet {
            cellFactory.registerAllCells(collectionView: self)
        }
    }
    private var sectionFactory: UniversalCollectionViewSectionFactoryProtocol! {
        didSet {
            sectionFactory?.registerAllViews(collectionView: self)
        }
    }
    private var layout: UniversalCollectionViewLayoutProtocol! {
        didSet {
            collectionViewLayout = layout.collectionViewLayout
        }
    }
    
    // MARK: - Public methods
    
    func start(viewModel: UniversalCollectionViewViewModel,
               cellFactory: UniversalCollectionViewCellFactoryProtocol,
               sectionFactory: UniversalCollectionViewSectionFactoryProtocol,
               layout: UniversalCollectionViewLayoutProtocol) {
        self.viewModel = viewModel
        self.cellFactory = cellFactory
        self.sectionFactory = sectionFactory
        self.layout = layout
        
        dataSource = self
        delegate = self
        
        reloadData()
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //addTapGesture()
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.tableSections.enumerated().forEach({ (index, section) in
            section.reload.sink(receiveValue: { [weak self] in
                self?.reloadSections(IndexSet(integer: index))
            }).store(in: &cancellable)
        })
    }
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didEndEditing))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc
    private func didEndEditing() {
        endEditing(true)
    }
    
}

// MARK: - UICollectionViewDataSource

extension UniversalCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.tableSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.tableSections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.tableSections[indexPath.section].cells[indexPath.row]
        return cellFactory.generateCell(cellViewModel: cellViewModel, collectionView: collectionView, indexPath: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegate

extension UniversalCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCellAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionViewModel = viewModel.tableSections[indexPath.section].sectionViewModel else {
            return UICollectionReusableView()
        }
        return sectionFactory.generateView(sectionViewModel: sectionViewModel, collectionView: collectionView, indexPath: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UniversalCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        layout.sizeForItemAt(collectionView, indexPath: indexPath)
    }
    
}
