//
//  SearchBarCollectionReusableViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol SearchBarCollectionReusableInputProtocol {
    var text: String { get }
}

protocol SearchBarCollectionReusableOutputProtocol {
    func textDidChange(_ text: String)
    func fiterAction()
    func cancelAction()
}

final class SearchBarCollectionReusableViewModel: CollectionReusableViewModelProtocol {
    
    // MARK: - Private properties
    
    private let textDidChange: (String) -> Void
    private let didFiter: () -> Void
    private let didCancle: () -> Void
    
    private var searchText: String {
        didSet {
            textDidChange(searchText)
        }
    }
    
    // MARK: - Init
    
    init(textDidChange: @escaping (String) -> Void,
         didFiter: @escaping () -> Void,
         didCancle: @escaping () -> Void) {
        self.textDidChange = textDidChange
        self.didFiter = didFiter
        self.didCancle = didCancle
        self.searchText = ""
    }
    
}

// MARK: - SearchBarCollectionReusableInputProtocol

extension SearchBarCollectionReusableViewModel: SearchBarCollectionReusableInputProtocol {
    
    var text: String {
        searchText
    }
    
}

// MARK: - SearchBarCollectionReusableOutputProtocol

extension SearchBarCollectionReusableViewModel: SearchBarCollectionReusableOutputProtocol {
    
    func textDidChange(_ text: String) {
        searchText = text
    }
    
    func fiterAction() {
        didFiter()
    }
    
    func cancelAction() {
        didCancle()
    }
    
}

