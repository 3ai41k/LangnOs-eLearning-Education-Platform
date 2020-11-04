//
//  SecurityManager.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol SessionInfoProtocol {
    var userInfo: UserInfoProtocol { get }
    func getUserPhoto(_ completion: @escaping (UIImage?) -> Void)
    func removeUserPhoto(_ completion: @escaping () -> Void)
    func updateUserPhoto(_ photo: UIImage, completion: @escaping () -> Void)
}

final class UserSession {
    
    // MARK: - Public properties
    
    static let shared = UserSession()
    
    // MARK: - Private properties
    
    private var _userInfo: UserInfoProtocol & UserInfoChangeStateProtocol
    private let userProfile: UserProfileExtandableProtocol
    private let mediaDownloader: MediaDownloadableProtocol
    private let storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol
    
    private var coreDataStack: CoreDataStack {
        CoreDataStack.shared
    }
    
    private var networkState: InternetConnectableProtocol {
        NetworkState.shared
    }
    
    private var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    // MARK: - Init
    
    private init() {
        self._userInfo = UserInfo()
        self.userProfile = UserProfile()
        self.mediaDownloader = MediaDownloader()
        self.storage = FirebaseStorage()
        
        self.setupUserInfoChangeStateNotifications()
    }
    
    // MARK: - Private methods
    
    private func setupUserInfoChangeStateNotifications() {
        _userInfo.didNewUserLoginHandler = {
            NotificationCenter.default.post(name: .didNewUserLogin, object: nil)
        }
        _userInfo.didUserLogoutHandler = {
            self.clearUserMetaData()
            NotificationCenter.default.post(name: .didUserLogout, object: nil)
        }
    }
    
    private func clearUserMetaData() {
        userDefaults.removeObject(forKey: UserDefaultsKey.userImage.rawValue)
        coreDataStack.clear()
    }
    
}

// MARK: - SessionInfoProtocol

extension UserSession: SessionInfoProtocol {
    
    var userInfo: UserInfoProtocol {
        _userInfo
    }
    
    func getUserPhoto(_ completion: @escaping (UIImage?) -> Void) {
        if let data = userDefaults.data(forKey: UserDefaultsKey.userImage.rawValue) {
            completion(UIImage(data: data))
        } else {
            if networkState.isReachable, let photoURL = _userInfo.photoURL {
                mediaDownloader.downloadMedia(url: photoURL, onSucces: { (data) in
                    self.userDefaults.set(data, forKey: UserDefaultsKey.userImage.rawValue)
                    completion(UIImage(data: data))
                }) { (error) in
                    print("Unresolved error \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func removeUserPhoto(_ completion: @escaping () -> Void) {
        let handleAnError: (Error) -> Void = { (error) in
            print("Unresolved error \(error.localizedDescription)")
            completion()
        }
        if networkState.isReachable, let userId = _userInfo.id {
            let request = DeleteUserImageFirestoreRequest(userId: userId)
            storage.delete(request: request, onSuccess: {
                self.userProfile.removePhoto(onSuccess: {
                    self.userDefaults.removeObject(forKey: UserDefaultsKey.userImage.rawValue)
                    completion()
                }, onFailure: handleAnError)
            }, onFailure: handleAnError)
        } else {
            print("There is not iternet connection")
            completion()
        }
    }
    
    func updateUserPhoto(_ image: UIImage, completion: @escaping () -> Void) {
        let handleAnError: (Error) -> Void = { (error) in
            print("Unresolved error \(error.localizedDescription)")
            completion()
        }
        if networkState.isReachable, let userId = _userInfo.id, let data = image.jpegData(compressionQuality: 0.25) {
            let request = UserImageFirestoreRequest(userId: userId, data: data)
            storage.upload(request: request, onSuccess: { (photoURL) in
                self.userProfile.updatePhoto(url: photoURL, onSuccess: {
                    self.userDefaults.set(data, forKey: UserDefaultsKey.userImage.rawValue)
                    completion()
                }, onFailure: handleAnError)
            }, onFailure: handleAnError)
        } else {
            print("There is not iternet connection")
            completion()
        }
    }
    
}
