//
//  FetchTermImageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 10.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct FetchTermImageRequest {
    
    // MARK: - Public properties
    
    let userId: String
    let vocabularyId: String
    let imageName: String
    
}

// MARK: - FirebaseFirestoreRequestProtocol

extension FetchTermImageRequest: FirebaseFirestoreRequestProtocol {
    
    var path: String {
        "users/\(userId)/images/vocabularies/\(vocabularyId)/\(imageName).jpg"
    }
    
}
