//
//  UserImageFirestoreRequest.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import FirebaseAuth

struct UserImageFirestoreRequest {
    
    // MARK: - Private properties
    
    private let user: User
    private let image: UIImage
    private let compressionQuality: CGFloat
    
    // MARK: - Init
    
    init(user: User, image: UIImage, compressionQuality: CGFloat) {
        self.user = user
        self.image = image
        self.compressionQuality = compressionQuality
    }
    
}

// MARK: - FirebaseFirestoreUploadRequestProtocol

extension UserImageFirestoreRequest: FirebaseFirestoreUploadRequestProtocol {
    
    var path: String {
        "user/\(user.uid)/images/profile/profileImage.jpg"
    }
    
    var data: Data? {
        image.jpegData(compressionQuality: compressionQuality)
    }
    
    var contentType: FirestoreContentType {
        .image
    }
    
}
