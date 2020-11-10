//
//  FirebaseFirestoreUploadRequestProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseStorage

enum FirestoreContentType: String {
    case image = "image/jpg"
}

protocol FirebaseFirestoreRequestProtocol {
    var path: String { get }
}

protocol FirebaseFirestoreUploadRequestProtocol: FirebaseFirestoreRequestProtocol {
    var imageData: Data { get }
    var contentType: FirestoreContentType { get }
    var metaData: StorageMetadata { get }
}

extension FirebaseFirestoreUploadRequestProtocol {
    
    var metaData: StorageMetadata {
        let metadata = StorageMetadata()
        metadata.contentType = contentType.rawValue
        return metadata
    }
    
}
