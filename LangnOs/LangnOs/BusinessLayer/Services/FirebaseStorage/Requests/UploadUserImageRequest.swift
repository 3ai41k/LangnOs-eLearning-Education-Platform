//
//  UploadUserImageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

struct UploadUserImageRequest {
    
    // MARK: - Public properties
    
    let userId: String
    let imageData: Data
    
}

// MARK: - FirebaseFirestoreUploadRequestProtocol

extension UploadUserImageRequest: FirebaseFirestoreUploadRequestProtocol {
    
    var path: String {
        "users/\(userId)/images/profileImage.jpg"
    }
    
    var contentType: FirestoreContentType {
        .image
    }
    
}
