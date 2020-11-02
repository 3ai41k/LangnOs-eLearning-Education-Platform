//
//  DictionaryEncoder.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class DictionaryEncoder {
    
    func encode<Entity: Encodable>(entity: Entity) throws -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(entity)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: [])
            return dictionary as! [String: Any]
        } catch {
            throw error
        }
    }
    
}
