//
//  CreateWordTableViewCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol VocabularyCellViewModelInputProtocol {
    var headerTitle: CurrentValueSubject<String?, Never> { get }
    var headerValue: String? { get }
    var footerTitle: CurrentValueSubject<String?, Never> { get }
    var footerValue: String? { get }
    var image: CurrentValueSubject<UIImage?, Never> { get }
    var toolbarDrivableModel: DrivableModelProtocol? { get }
    var isEditable: CurrentValueSubject<Bool, Never> { get }
}

protocol VocabularyCellViewModelOutputProtocol {
    func setHeaderValue(_ text: String)
    func setFooterValue(_ text: String)
}

typealias VocabularyCellViewModelProtocol =
    VocabularyCellViewModelInputProtocol &
    VocabularyCellViewModelOutputProtocol &
    CellViewModelProtocol

class VocabularyCellViewModel: VocabularyCellViewModelProtocol {
    
    // MARK: - Public properties
    
    var headerTitle: CurrentValueSubject<String?, Never>
    var headerValue: String? {
        nil
    }
    var footerTitle: CurrentValueSubject<String?, Never>
    var footerValue: String? {
        nil
    }
    var image: CurrentValueSubject<UIImage?, Never>
    var toolbarDrivableModel: DrivableModelProtocol? {
        nil
    }
    var isEditable: CurrentValueSubject<Bool, Never>
    
    // MARK: - Init
    
    init(headerTitle: String, footerTitle: String) {
        self.headerTitle = .init(headerTitle)
        self.footerTitle = .init(footerTitle)
        self.image = .init(nil)
        self.isEditable = .init(true)
    }
    
    func setHeaderValue(_ text: String) { }
    
    func setFooterValue(_ text: String) { }
    
}

