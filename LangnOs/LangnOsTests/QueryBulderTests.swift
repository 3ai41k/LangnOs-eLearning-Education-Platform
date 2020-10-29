//
//  QueryBulderTests.swift
//  LangnOsTests
//
//  Created by Nikita Lizogubov on 29.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import XCTest
@testable import LangnOs

class QueryBulderTests: XCTestCase {
    
    func testIsDatabaseQueryNotNil() {
        let userId = UUID().uuidString
        
        let andConnector1 = QueryAndConnector(componets: [
            IsEqualToComponent("userId", isEqualTo: userId),
        ])
        
        let andConnector2 = QueryAndConnector(componets: [
            IsEqualToComponent("isFavorite", isEqualTo: true),
        ])
        
        let queryBulder = QueryBulder(connectors: [
            andConnector1, andConnector2
        ])
        
        XCTAssertNotNil(queryBulder.databaseQuery())
    }
    
    func testIsDatabaseQueryNil() {
        let queryBulder = QueryBulder(connectors: [])
        
        XCTAssertNil(queryBulder.databaseQuery())
    }

    func testAndConnector() {
        let userId = UUID().uuidString
        
        let andConnector = QueryAndConnector(componets: [
            IsEqualToComponent("userId", isEqualTo: userId),
            IsEqualToComponent("isFavorite", isEqualTo: true),
            IsEqualToComponent("isPrivate", isEqualTo: false)
        ])
        
        XCTAssertEqual(andConnector.databaseFormat(), "userId == %@ AND isFavorite == %@ AND isPrivate == %@")
    }
    
    func testIsEqualToComonent() {
        let userId = UUID().uuidString
        
        let component = IsEqualToComponent("userId", isEqualTo: userId)
        
        XCTAssertEqual(component.format, "userId == ")
    }
    
}
