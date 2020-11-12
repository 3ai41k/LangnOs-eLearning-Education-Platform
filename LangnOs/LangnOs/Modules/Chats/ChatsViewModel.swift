//
//  ChatsViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 12.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol ChatsViewModelInputProtocol {
    var title: String { get }
}

protocol ChatsViewModelOutputProtocol {
    
}

typealias ChatsViewModelProtocol =
    ChatsViewModelInputProtocol &
    ChatsViewModelOutputProtocol &
    UniversalTableViewModelProtocol

final class ChatsViewModel: ChatsViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "Chats".localize
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: ChatsCoordinatorProtocol
    private let dataProvider: FirebaseDatabaseFetchingProtocol
    
    // MARK: - Init
    
    init(router: ChatsCoordinatorProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        
        self.appendChatSection()
        
        self.fetchData()
    }
    
    // MARK: - Public methods
    // MARK: - Private methods
    
    private func appendChatSection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func fetchData() {
        let request = FetchAllUsersRequest()
        dataProvider.fetch(request: request, onSuccess: { (users: [User1]) in
            self.tableSections[0].cells.value = users.map({ ChatCellViewModel(user: $0) })
        }, onFailure: router.showError)
    }
    
}


