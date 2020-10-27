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
    
    private let user: User
    
    // MARK: - Init
    
    init(user: User) {
        self.user = user
    }
    
}

// MARK: - FirestoreRequest

extension DeleteUserImageFirestoreRequest: FirebaseFirestoreDeleteRequestProtocol {
    
    var path: String {
        "user/\(user.uid)/images/profile/profileImage.jpg"
    }
    
}
