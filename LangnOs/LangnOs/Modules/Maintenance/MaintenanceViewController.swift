//
//  MaintenanceViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

final class MaintenanceViewController: BindibleViewController<MaintenanceViewModel> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var synchronizeView: UIView! {
        didSet {
            synchronizeView.layer.cornerRadius = 20.0
            synchronizeView.layer.opacity = .zero
        }
    }
    @IBOutlet private weak var synchronizeLabel: UIStackView!
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showSynchronizeView()
    }
    
    // MARK: - Override
    
    override func bindViewModel() {
        viewModel?.hideSynchronizeView = { [weak self] in self?.hideSynchronizeView() }
    }
    
    // MARK: - Private methods
    
    private func showSynchronizeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.synchronizeView.layer.opacity = 1.0
        }) { (finished) in
            self.viewModel?.synchronize()
        }
    }
    
    private func hideSynchronizeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.synchronizeView.layer.opacity = .zero
        }) { (finished) in
            self.viewModel?.close()
        }
    }
    
}

