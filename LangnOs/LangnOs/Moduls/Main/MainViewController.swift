//
//  MainViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

typealias MainViewModelType = MainViewModelInputProtocol & MainViewModelOutputProtocol & UniversalCollectionViewViewModel

final class MainViewController: BindibleViewController<MainViewModelType> {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var topBarView: UIView! {
        didSet {
            topBarView.layer.cornerRadius = 20.0
            topBarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            topBarView.setShadow(color: .black, opacity: 0.25)
        }
    }
    @IBOutlet private weak var fiexedCollectionView: UniversalCollectionView! {
        didSet {
            guard
                let viewModel = viewModel,
                let cellFactory = collectionViewCellFactory,
                let sectionFactory = collectionViewSectionFactory,
                let layout = collectionViewLayout
            else {
                return
            }
            
            fiexedCollectionView.start(viewModel: viewModel,
                                       cellFactory: cellFactory,
                                       sectionFactory: sectionFactory,
                                       layout: layout)
        }
    }
    
    // MARK: - Publiec properties
    
    var collectionViewCellFactory: UniversalCollectionViewCellFactoryProtocol?
    var collectionViewSectionFactory: UniversalCollectionViewSectionFactoryProtocol?
    var collectionViewLayout: UniversalCollectionViewLayoutProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.fetchData()
    }
    
    // MARK: - Override
    
    override func setupUI() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }

}
