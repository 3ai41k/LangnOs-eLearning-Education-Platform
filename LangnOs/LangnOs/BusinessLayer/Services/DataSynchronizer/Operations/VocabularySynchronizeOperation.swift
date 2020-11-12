//
//  VocabularySynchronizeOperation.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 02.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

final class VocabularySynchronizeOperation: SynchronizeOperation {
    
    // MARK: - Private methods
    
    private let dispatchGroup: DispatchGroup
    
    // MARK: - Init
    
    override init(completion: @escaping () -> Void) {
        self.dispatchGroup = DispatchGroup()
        
        super.init(completion: completion)
    }
    
    // MARK: - Override
    
    override func syncronize() {
        let vocabularies = getUnsynchronizedVocabularies()
        if vocabularies.isEmpty {
            state = .finished
        } else {
            vocabularies.forEach({ (vocabulary) in
                dispatchGroup.enter()
                
                let reqest = VocabularyCreateRequest(vocabulary: vocabulary)
                self.firebaseDatabase.create(request: reqest, onSuccess: {
                    self.updateVocabulary(vocabulary)
                    self.dispatchGroup.leave()
                }, onFailure: self.handleAnError)
            })
            dispatchGroup.notify(queue: .main) {
                self.state = .finished
            }
        }
    }
    
    // MARK: - Private methods
    
    private func getUnsynchronizedVocabularies() -> [Vocabulary] {
        guard let userId = UserSession.shared.currentUser?.id else { return [] }
        do {
            return try VocabularyEntity.selectUnsynchronized(userId: userId)
        } catch {
            handleAnError(error)
        }
        return .empty
    }
    
    private func updateVocabulary(_ vocabulary: Vocabulary) {
        do {
            try VocabularyEntity.update(entity: vocabulary)
        } catch {
            handleAnError(error)
        }
    }
    
    private func handleAnError(_ error: Error) {
        print("Unresolved error \(error.localizedDescription)")
        state = .finished
    }
    
}
