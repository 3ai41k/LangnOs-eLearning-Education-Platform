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

private enum SectionType: Int {
    case chats
}

final class ChatsViewModel: ChatsViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "Chats".localize
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: ChatsCoordinatorProtocol
    private let dataProvider: FirebaseDatabaseFetchingProtocol
    
    private var chats: [Chat] = [] {
        didSet {
            let cellViewModels = chats.map({ ChatCellViewModel(chat: $0) })
            tableSections[SectionType.chats.rawValue].cells.value = cellViewModels
        }
    }
    
    // MARK: - Init
    
    init(router: ChatsCoordinatorProtocol,
         dataProvider: FirebaseDatabaseFetchingProtocol) {
        self.router = router
        self.dataProvider = dataProvider
        
        self.appendChatSection()
        
        self.fetchData()
    }
    
    // MARK: - Publis methods
    
    func didSelectCellAt(indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        router.navigateToChat(chat)
    }
    
    // MARK: - Private methods
    
    private func appendChatSection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func fetchData() {
        let request = FetchChatsRequest()
        dataProvider.fetch(request: request, onSuccess: { (chats: [Chat]) in
            self.chats = chats
        }, onFailure: router.showError)
    }
    
}

