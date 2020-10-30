//
//  DeleteUserImageFirestoreRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 17.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseAuth

struct DeleteUserImageFirestoreRequest {
    
    // MARK: - Private properties
    
    private let userId: String
    
    // MARK: - Init
    
    init(userId: String) {
        self.userId = userId
    }
    
}

// MARK: - FirestoreRequest

extension DeleteUserImageFirestoreRequest: FirebaseFirestoreDeleteRequestProtocol {
    
    var path: String {
        "users/\(userId)/images/profileImage.jpg"
    }
    
}
