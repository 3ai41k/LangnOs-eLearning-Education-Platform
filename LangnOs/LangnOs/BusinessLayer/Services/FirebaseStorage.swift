//
//  FirebaseStorage.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

enum FirebaseStorageError: Error {
    case dataNotFound
    case urlNotFound
}

protocol FirebaseStorageUploadingProtocol {
    func upload(request: FirebaseFirestoreUploadRequestProtocol, completion: @escaping (Result<URL, Error>) -> Void)
}

protocol FirebaseStorageRemovingProtocol {
    func delete(request: FirebaseFirestoreDeleteRequestProtocol, completion: @escaping (Error?) -> Void)
}

final class FirebaseStorage {
    
    private var storage: Storage {
        Storage.storage()
    }
    
}

// MARK: - FirebaseStorageUploadingProtocol

extension FirebaseStorage: FirebaseStorageUploadingProtocol {
    
    func upload(request: FirebaseFirestoreUploadRequestProtocol, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let data = request.data else {
            completion(.failure(FirebaseStorageError.dataNotFound))
            return
        }
        
        let reference = storage.reference(withPath: request.path)
        reference.putData(data, metadata: request.metaData) { (metaData, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                reference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        guard let url = url else {
                            completion(.failure(FirebaseStorageError.urlNotFound))
                            return
                        }
                        completion(.success(url))
                    }
                }
            }
        }
    }
    
}

// MARK: - FirebaseStorageRemovingProtocol

extension FirebaseStorage: FirebaseStorageRemovingProtocol {
    
    func delete(request: FirebaseFirestoreDeleteRequestProtocol, completion: @escaping (Error?) -> Void) {
        let reference = storage.reference(withPath: request.path)
        reference.delete { (error) in
            completion(error)
        }
    }
    
}
