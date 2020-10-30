//
//  QueryBulderTests.swift
//  LangnOsTests
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import XCTest
@testable import FirebaseFirestore
@testable import LangnOs

final class QueryBulderTests: XCTestCase {
    
    func testAndOrConnectorForDatabase() {
        let userId = UUID().uuidString
        
        let connector = QueryAndConnector(components: [
            IsEqualToComponent("userId", isEqualTo: userId),
            IsEqualToComponent("isFavorite", isEqualTo: true),
            QueryOrConnector(components: [
                IsEqualToComponent("isPrivate", isEqualTo: false),
                IsEqualToComponent("isEditable", isEqualTo: true)
            ])
        ])
        
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "%@ == %@", argumentArray: ["userId", userId]),
            NSPredicate(format: "%@ == %@", argumentArray: ["isFavorite", true]),
            NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "%@ == %@", argumentArray: ["isPrivate", false]),
                NSPredicate(format: "%@ == %@", argumentArray: ["isEditable", true])
            ])
        ])
        
        print(#function, ": ", connector.databaseQuery(), " - ", predicates)
        
        XCTAssertEqual(connector.databaseQuery(), predicates)
    }
    
    func testOrConnectorForDatabase() {
        let userId = UUID().uuidString
        
        let andConnector = QueryOrConnector(components: [
            IsEqualToComponent("userId", isEqualTo: userId),
            IsEqualToComponent("isFavorite", isEqualTo: true),
            IsEqualToComponent("isPrivate", isEqualTo: false),
        ])
        
        let predicates = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "%@ == %@", argumentArray: ["userId", userId]),
            NSPredicate(format: "%@ == %@", argumentArray: ["isFavorite", true]),
            NSPredicate(format: "%@ == %@", argumentArray: ["isPrivate", false])
        ])
        
        print(#function, ": ", andConnector.databaseQuery(), " - ", predicates)
        
        XCTAssertEqual(andConnector.databaseQuery(), predicates)
    }
    
    func testAndConnectorForFirebase() {
        let userId = UUID().uuidString
        
        let andConnector = QueryAndConnector(components: [
            IsEqualToComponent("userId", isEqualTo: userId),
            IsEqualToComponent("isFavorite", isEqualTo: true)
        ])
        
        let collectionReference = Firestore.firestore().collection(CollectionPath.vocabularies.rawValue)
        let query = collectionReference.whereField("userId", isEqualTo: userId).whereField("isFavorite", isEqualTo: true)
        
        print(#function, ": ", andConnector.firebaseQuery(collectionReference), " - ", query)
        
        XCTAssertEqual(andConnector.firebaseQuery(collectionReference), query)
    }

    func testAndConnectorForDatabase() {
        let userId = UUID().uuidString
        
        let andConnector = QueryAndConnector(components: [
            IsEqualToComponent("userId", isEqualTo: userId),
            IsEqualToComponent("isFavorite", isEqualTo: true),
            IsEqualToComponent("isPrivate", isEqualTo: false),
        ])
        
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "%@ == %@", argumentArray: ["userId", userId]),
            NSPredicate(format: "%@ == %@", argumentArray: ["isFavorite", true]),
            NSPredicate(format: "%@ == %@", argumentArray: ["isPrivate", false])
        ])
        
        print(#function, ": ", andConnector.databaseQuery(), " - ", predicates)
        
        XCTAssertEqual(andConnector.databaseQuery(), predicates)
    }
    
    func testIsEqualToComonentForFirebase() {
        let userId = UUID().uuidString
        
        let component = IsEqualToComponent("userId", isEqualTo: userId)
        
        let collectionReference = Firestore.firestore().collection(CollectionPath.vocabularies.rawValue)
        let query = collectionReference.whereField("userId", isEqualTo: userId)
        
        print(#function, ": ", component.firebaseQuery(collectionReference), " - ", query)
        
        XCTAssertEqual(component.firebaseQuery(collectionReference), query)
    }
    
    func testIsEqualToComonentForDatabase() {
        let userId = UUID().uuidString
        
        let component = IsEqualToComponent("userId", isEqualTo: userId)
        
        let predicate = NSPredicate(format: "%@ == %@", argumentArray: ["userId", userId])
        
        print(#function, ": ", component.databaseQuery(), " - ", predicate)
        
        XCTAssertEqual(component.databaseQuery(), predicate)
    }
    
}
