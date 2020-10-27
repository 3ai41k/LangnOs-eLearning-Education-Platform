//
//  DictionaryDecoder.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

final class DictionaryDecoder {
    
    func decode<Entity: Decodable>(data: Any) throws -> Entity {
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let entity = try JSONDecoder().decode(Entity.self, from: data)
            return entity
        } catch {
            throw error
        }
    }
    
}
