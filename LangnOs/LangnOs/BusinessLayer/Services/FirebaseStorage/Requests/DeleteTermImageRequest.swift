//
//  DeleteTermImageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 06.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct DeleteTermImageRequest {
    
    // MARK: - Public properties
    
    let userId: String
    let vocabularyId: String
    let imageName: String
    
}

// MARK: - FirebaseFirestoreUploadRequestProtocol

extension DeleteTermImageRequest: FirebaseFirestoreRequestProtocol {
    
    var path: String {
        "users/\(userId)/images/vocabularies/\(vocabularyId)/\(imageName).jpg"
    }
    
    var contentType: FirestoreContentType {
        .image
    }
    
}
