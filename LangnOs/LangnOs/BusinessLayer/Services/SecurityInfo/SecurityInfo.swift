//
//  SecurityInfo.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 09.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserInfoProtocol {
    var userId: String? { get }
}

final class SecurityInfo {
    
    private var auth: Auth {
        Auth.auth()
    }
    
}

// MARK: - UserInfoProtocol

extension SecurityInfo: UserInfoProtocol {
    
    var userId: String? {
        auth.currentUser?.uid
    }
    
}
