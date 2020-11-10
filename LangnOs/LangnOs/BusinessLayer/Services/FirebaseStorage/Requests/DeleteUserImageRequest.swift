//
//  DeleteUserImageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 17.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct DeleteUserImageRequest {
    
    // MARK: - Public properties
    
    let userId: String
    
}

// MARK: - FirestoreRequest

extension DeleteUserImageRequest: FirebaseFirestoreRequestProtocol {
    
    var path: String {
        "users/\(userId)/images/profileImage.jpg"
    }
    
}
