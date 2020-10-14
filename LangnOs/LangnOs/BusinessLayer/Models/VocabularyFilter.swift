//
//  VocabularyFilter.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import CoreData

struct VocabularyFilter {
    let name: String
    let value: String
}

// MARK: - FDEntityProtocol

extension VocabularyFilter: FDEntityProtocol {
    
    init(dictionary: [String : Any]) {
        self.name = dictionary["name"] as! String
        self.value = dictionary["value"] as! String
    }
    
    var serialize: [String : Any] {
        [
            "name": name,
            "value": value
        ]
    }
    
}

// MARK: - CDEntityProtocol

extension VocabularyFilter: CDEntityProtocol {
    
    private init(entity: VocabularyFilterEntity) {
        self.name = entity.name!
        self.value = entity.value!
    }
    
    static func select(context: NSManagedObjectContext) throws -> [VocabularyFilter] {
        let request = NSFetchRequest<VocabularyFilterEntity>(entityName: "VocabularyFilterEntity")
        do {
            return try context.fetch(request).map({
                VocabularyFilter(entity: $0)
            })
        } catch {
            throw error
        }
    }
    
    func insert(context: NSManagedObjectContext) {
        let vocabularyFilter = VocabularyFilterEntity(context: context)
        vocabularyFilter.name = name
    }
    
    func delete(context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<VocabularyFilterEntity>(entityName: "VocabularyFilterEntity")
        do {
            let vocabularies = try context.fetch(request)
            if let vocabularyFilterForDelete = vocabularies.first(where: { $0.name == name }) {
                context.delete(vocabularyFilterForDelete)
            } else {
                throw DataFacadeError.entityHasNoFound
            }
        } catch {
            throw error
        }
    }
    
}
