//
//  UploadTermImageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 05.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

struct UploadTermImageRequest {
    
    // MARK: - Public properties
    
    let userId: String
    let vocabularyId: String
    let imageId: String
    let image: UIImage
    
}

// MARK: - FirebaseFirestoreUploadRequestProtocol

extension UploadTermImageRequest: FirebaseFirestoreUploadRequestProtocol {
    
    var imageData: Data {
        image.jpegData(compressionQuality: 0.25)!
    }
    
    var contentType: FirestoreContentType {
        .image
    }
    
    var path: String {
        "users/\(userId)/images/vocabularies/\(vocabularyId)/\(imageId).jpg"
    }
    
}
