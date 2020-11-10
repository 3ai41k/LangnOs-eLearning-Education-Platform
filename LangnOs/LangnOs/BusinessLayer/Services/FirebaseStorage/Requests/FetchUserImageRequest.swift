//
//  FetchUserImageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 10.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct FetchUserImageRequest {
    
    // MARK: - Public properties
    
    let userId: String
    
}

// MARK: - FirebaseFirestoreRequestProtocol

extension FetchUserImageRequest: FirebaseFirestoreRequestProtocol {
    
    var path: String {
        "users/\(userId)/images/profileImage.jpg"
    }
    
}
