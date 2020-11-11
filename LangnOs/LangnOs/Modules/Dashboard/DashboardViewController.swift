//
//  DashboardViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 01.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class DashboardViewController: BindibleViewController<DashboardViewModelProtocol> {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = cellFactory
            tableView.sectionFactory = sectionFactory
            
            tableView.start()
        }
    }
    
    // MARK: - Publiec properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    var sectionFactory: SectionViewFactoryProtocol?
    
    // MARK: - Override
    
    override func bindViewModel() {
        navigationController?.navigationBar.topItem?.title = viewModel?.title
        cancellables = [
            viewModel?.userImage.sink(receiveValue: { [weak self] (image) in
                if let image = image {
                    self?.setupUserProfileButton(image: image)
                } else {
                    self?.setupActivityButton()
                }
            }),
            viewModel?.titleViewStatePublisher.sink(receiveValue: { [weak self] (state) in
                switch state {
                case .offline:
                    self?.navigationController?.navigationBar.topItem?.titleView = OfflineTitleView()
                case .hide:
                    self?.navigationController?.navigationBar.topItem?.titleView = nil
                }
            })
        ]
    }
    
    override func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private methods
    
    // TO DO: Create custom view
    
    private func setupUserProfileButton(image: UIImage) {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didProfileTouch), for: .touchUpInside)
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 16.0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 32.0),
            button.widthAnchor.constraint(equalToConstant: 32.0)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func setupActivityButton() {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    }
    
    // MARK: - Actions
    
    @objc
    private func didProfileTouch() {
        viewModel?.userProfileAction()
    }

}
