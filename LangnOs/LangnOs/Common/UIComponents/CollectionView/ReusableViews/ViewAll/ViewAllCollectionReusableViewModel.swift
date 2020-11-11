//
//  ViewAllCollectionReusableViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 20.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol ViewAllCollectionReusableViewModelInputProtocol {
    
}

protocol ViewAllCollectionReusableViewModelOutputProtocol {
    
}

typealias ViewAllCollectionReusableViewModelProtocol =
    ViewAllCollectionReusableViewModelInputProtocol &
    ViewAllCollectionReusableViewModelOutputProtocol

final class ViewAllCollectionReusableViewModel: CollectionReusableViewModelProtocol, ViewAllCollectionReusableViewModelProtocol {
    
}
