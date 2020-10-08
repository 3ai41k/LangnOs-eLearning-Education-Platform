//
//  SearchBarCollectionReusableView.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class SearchBarCollectionReusableView: UICollectionReusableView, UniversalCollectionViewSectionRegistratable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    // MARK: - Public properties
    
    var viewModel: (SearchBarCollectionReusableInputProtocol & SearchBarCollectionReusableOutputProtocol)? {
        didSet {
            searchBar.text = viewModel?.text
        }
    }
    
    // MARK: - Actions
    
    @IBAction
    private func didFilterTouched(_ sender: Any) {
        viewModel?.fiterAction()
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchBarCollectionReusableView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel?.cancelAction()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel?.textDidChange(text)
    }
    
}
