//
//  Sequence+KeyPathSorting.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

extension Sequence {
    
    func sorted<Value>(by keyPath: KeyPath<Self.Element, Value>, using valuesAreInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Self.Element] {
        return try self.sorted(by: {
            try valuesAreInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        })
    }
    
    func filter<T: Equatable>(where keyPath: KeyPath<Element, T>, equals compareValue: T) -> [Element] {
        return filter { $0[keyPath: keyPath] == compareValue }
    }
    
}
