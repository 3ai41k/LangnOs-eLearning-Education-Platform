//
//  StudyResultViewController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 20.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class StudyResultViewController: BindibleViewController<StudyResultViewModelProtocol> {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var roundResultLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var startNewRoundButton: BorderedButton!
    
    // MARK: - Public properties
    
    
    
    
    // MARK: - Private properties
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    // MARK: - Init
    
    
    
    
    // MARK: - Override
    
    override func bindViewModel() {
        
    }
    
    override func setupUI() {
        
    }
    
    override func configurateComponents() {
        
    }
    
    // MARK: - Public methods
    
    
    
    
    // MARK: - Private methods
    
    
    
    // MARK: - Actions
    
    @IBAction
    private func didCloseTouch(_ sender: Any) {
        viewModel?.actionSubject.send(.close)
    }
    
    @IBAction
    private func didStartNewRoundTouch(_ sender: Any) {
        viewModel?.actionSubject.send(.close)
    }
    
    
}

