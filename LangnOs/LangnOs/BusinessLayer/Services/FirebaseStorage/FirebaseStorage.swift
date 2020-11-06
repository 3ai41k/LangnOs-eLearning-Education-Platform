//
//  FirebaseStorage.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseStorage

enum FirebaseStorageError: Error {
    case urlNotFound
}

protocol FirebaseStorageUploadingProtocol {
    func upload(request: FirebaseFirestoreUploadRequestProtocol, onSuccess: @escaping (URL) -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseStorageRemovingProtocol {
    func delete(request: FirebaseFirestoreDeleteRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

final class FirebaseStorage {
    
    private var storage: Storage {
        Storage.storage()
    }
    
}

// MARK: - FirebaseStorageUploadingProtocol

extension FirebaseStorage: FirebaseStorageUploadingProtocol {
    
    func upload(request: FirebaseFirestoreUploadRequestProtocol, onSuccess: @escaping (URL) -> Void, onFailure: @escaping (Error) -> Void) {
        let reference = storage.reference(withPath: request.path)
        reference.putData(request.imageData, metadata: request.metaData) { (metaData, error) in
            if let error = error {
                onFailure(error)
            } else {
                reference.downloadURL { (url, error) in
                    if let error = error {
                        onFailure(error)
                    } else {
                        guard let url = url else {
                            onFailure(FirebaseStorageError.urlNotFound)
                            return
                        }
                        onSuccess(url)
                    }
                }
            }
        }
    }
    
}

// MARK: - FirebaseStorageRemovingProtocol

extension FirebaseStorage: FirebaseStorageRemovingProtocol {
    
    func delete(request: FirebaseFirestoreDeleteRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        let reference = storage.reference(withPath: request.path)
        reference.delete { (error) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
}
