//
//  UploadUserImageRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

struct UploadUserImageRequest {
    
    // MARK: - Public properties
    
    let userId: String
    let image: UIImage
    
}

// MARK: - FirebaseFirestoreUploadRequestProtocol

extension UploadUserImageRequest: FirebaseFirestoreUploadRequestProtocol {
    
    var imageData: Data {
        image.jpegData(compressionQuality: 0.25)!
    }
    
    var path: String {
        "users/\(userId)/images/profileImage.jpg"
    }
    
    var contentType: FirestoreContentType {
        .image
    }
    
}
