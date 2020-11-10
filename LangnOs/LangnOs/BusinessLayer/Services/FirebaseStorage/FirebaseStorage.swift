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

protocol FirebaseStorageFetchingProtocol {
    func fetch(request: FirebaseFirestoreRequestProtocol, onSuccess: @escaping (UIImage?) -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseStorageUploadingProtocol {
    func upload(request: FirebaseFirestoreUploadRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

protocol FirebaseStorageRemovingProtocol {
    func delete(request: FirebaseFirestoreRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

final class FirebaseStorage {
    
    // MARK: - Private properties
    
    private var storage: Storage {
        Storage.storage()
    }
    
}

// MARK: - FirebaseStorageFetchingProtocol

extension FirebaseStorage: FirebaseStorageFetchingProtocol {
    
    func fetch(request: FirebaseFirestoreRequestProtocol, onSuccess: @escaping (UIImage?) -> Void, onFailure: @escaping (Error) -> Void) {
        let reference = storage.reference(withPath: request.path)
        reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                onFailure(error)
            } else {
                if let data = data {
                    let image = UIImage(data: data)
                    onSuccess(image)
                } else {
                    onSuccess(nil)
                }
            }
        }
    }
    
}

// MARK: - FirebaseStorageUploadingProtocol

extension FirebaseStorage: FirebaseStorageUploadingProtocol {
    
    func upload(request: FirebaseFirestoreUploadRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        let reference = storage.reference(withPath: request.path)
        reference.putData(request.imageData, metadata: request.metaData) { (metaData, error) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
}

// MARK: - FirebaseStorageRemovingProtocol

extension FirebaseStorage: FirebaseStorageRemovingProtocol {
    
    func delete(request: FirebaseFirestoreRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
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
