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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.fetchFavoriteVocabulary()
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        cancellables = [
            viewModel?.title.sink(receiveValue: { [weak self] (title) in
                self?.navigationController?.navigationBar.topItem?.title = title
            }),
            viewModel?.isOfflineTitleHiddenPublisher.sink(receiveValue: { [weak self] (isHidden) in
                self?.navigationController?.navigationBar.topItem?.titleView?.isHidden = !isHidden
                UIView.animate(withDuration: 0.3, animations: {
                    self?.navigationController?.navigationBar.topItem?.titleView?.layer.opacity = isHidden ? 0.0 : 1.0
                }) { (finished) in
                    self?.navigationController?.navigationBar.topItem?.titleView?.isHidden = isHidden
                }
            })
        ]
    }
    
    override func configurateComponents() {
        setupPullToRefresh()
    }
    
    override func setupUI() {
        let userButton = UIBarButtonItem(image: SFSymbols.personCircle(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didUserTouch))
        
        navigationItem.leftBarButtonItem = userButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.titleView = OfflineTitleView()
    }
    
    // MARK: - Private methods
    
    private func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    // MARK: - Actions
    
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        viewModel?.refreshData {
            sender.endRefreshing()
        }
    }
    
    @objc
    private func didUserTouch() {
        viewModel?.userProfileAction()
    }

}
