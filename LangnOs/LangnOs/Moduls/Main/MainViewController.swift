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
    
    @IBOutlet private weak var fiexedCollectionView: UniversalCollectionView! {
        didSet {
            guard let viewModel = viewModel, let cellFactory = collectionViewCellFactory else { return }
            fiexedCollectionView.start(viewModel: viewModel, cellFactory: cellFactory)
        }
    }
    
    // MARK: - Publiec properties
    
    var collectionViewCellFactory: UniversalCollectionViewCellFactoryProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.fetchData()
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Private methods
    
    private func initializeComponents() {
        navigationItem.drive(model: viewModel?.navigationItemDrivableModel)
        navigationController?.navigationBar.drive(model: viewModel?.navigationBarDrivableModel)
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didSingInTouch(_ sender: Any) {
        viewModel?.singInAction()
    }

}
