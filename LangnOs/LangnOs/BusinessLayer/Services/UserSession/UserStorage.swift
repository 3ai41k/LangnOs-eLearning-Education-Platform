//
//  UserMedia.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 10.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class UserStorage {
    
    // MARK: - Private properties
    
    private let storage: FirebaseStorageProtocol
    
    private var networkState: InternetConnectableProtocol {
        NetworkState.shared
    }
    
    private var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    // MARK: - Init
    
    init(storage: FirebaseStorageProtocol) {
        self.storage = storage
    }
    
}

// MARK: - FirebaseStorageFetchingProtocol

extension UserStorage: FirebaseStorageFetchingProtocol {
    
    func fetch(request: FirebaseFirestoreRequestProtocol, onSuccess: @escaping (UIImage?) -> Void, onFailure: @escaping (Error) -> Void) {
        if let data = userDefaults.data(forKey: UserDefaultsKey.userImage.rawValue) {
            onSuccess(UIImage(data: data))
        } else {
            if networkState.isReachable {
                storage.fetch(request: request, onSuccess: { (image) in
                    let imageData = image?.jpegData(compressionQuality: 0.25)
                    self.userDefaults.set(imageData, forKey: UserDefaultsKey.userImage.rawValue)
                    onSuccess(image)
                }, onFailure: onFailure)
            } else {
                onSuccess(nil)
            }
        }
    }
    
}

// MARK: - FirebaseStorageUploadingProtocol

extension UserStorage: FirebaseStorageUploadingProtocol {
    
    func upload(request: FirebaseFirestoreUploadRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        storage.upload(request: request, onSuccess: {
            self.userDefaults.set(request.imageData, forKey: UserDefaultsKey.userImage.rawValue)
            onSuccess()
        }, onFailure: onFailure)
    }
    
}

// MARK: - FirebaseStorageRemovingProtocol

extension UserStorage: FirebaseStorageRemovingProtocol {
    
    func delete(request: FirebaseFirestoreRequestProtocol, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        storage.delete(request: request, onSuccess: {
            self.userDefaults.removeObject(forKey: UserDefaultsKey.userImage.rawValue)
            onSuccess()
        }, onFailure: onFailure)
    }
    
}
