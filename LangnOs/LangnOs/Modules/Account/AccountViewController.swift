//
//  AccountViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class AccountViewController: BindibleViewController<AccountViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UniversalTableView! {
        didSet {
            tableView.viewModel = viewModel
            tableView.cellFactory = cellFactory
            tableView.tableHeaderView = userInfoHeaderView
            
            tableView.start()
        }
    }
    
    // MARK: - Publiec properties
    
    var cellFactory: UniversalTableViewCellFactoryProtocol?
    
    // MARK: - Private proprties
    
    private var userInfoHeaderView: UserInfoHeaderView = {
        let rect = CGRect(x: .zero, y: .zero, width: .zero, height: 150.0)
        let view = UserInfoHeaderView(frame: rect)
        return view
    }()
    
    // MARK: - Override
    
    override func bindViewModel() {
        title = viewModel?.title
        
        userInfoHeaderView.name = viewModel?.username
        userInfoHeaderView.email = viewModel?.email
        userInfoHeaderView.editImageHandler = { [weak self] in
            self?.viewModel?.editPhoto()
        }
        
        cancellables = [
            viewModel?.userPhoto.assign(to: \.image, on: userInfoHeaderView)
        ]
    }

}
