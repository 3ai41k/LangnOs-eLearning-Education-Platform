//
//  UploadTermImageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct UploadTermImageRequest {
    
    // MARK: - Public properties
    
    let userId: String
    let vocabularyId: String
    let imageName: String
    let imageData: Data
    
}

// MARK: - FirebaseFirestoreUploadRequestProtocol

extension UploadTermImageRequest: FirebaseFirestoreUploadRequestProtocol {
    
    var path: String {
        "users/\(userId)/images/vocabularies/\(vocabularyId)/\(imageName).jpg"
    }
    
    var contentType: FirestoreContentType {
        .image
    }
    
}
