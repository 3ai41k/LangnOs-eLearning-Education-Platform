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
            synchronizeView.layer.cornerRadius = 25.0
            synchronizeView.transform = CGAffineTransform(translationX: .zero, y: -70.0)
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
        UIView.animate(withDuration: 0.2, animations: {
            self.synchronizeView.transform = CGAffineTransform(translationX: .zero, y: .zero)
        }) { (finished) in
            self.viewModel?.synchronize()
        }
    }
    
    private func hideSynchronizeView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.synchronizeView.transform = CGAffineTransform(translationX: .zero, y: -70.0)
        }) { (finished) in
            self.viewModel?.close()
        }
    }
    
}

