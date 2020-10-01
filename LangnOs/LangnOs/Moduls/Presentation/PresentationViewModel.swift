//
//  PresentationViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol PresentationViewModelInputProtocol {
    
}

protocol PresentationViewModelOutputProtocol {
    func startAction()
}

final class PresentationViewModel { }

// MARK: - PresentationViewModelInputProtocol

extension PresentationViewModel: PresentationViewModelInputProtocol {
    
}

// MARK: - PresentationViewModelOutputProtocol

extension PresentationViewModel: PresentationViewModelOutputProtocol {
    
    func startAction() {
        print(#function)
    }
    
}
