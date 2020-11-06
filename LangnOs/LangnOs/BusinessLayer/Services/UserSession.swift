//
//  SecurityManager.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol SessionInfoProtocol {
    var userInfo: UserInfoProtocol { get }
    func getUserPhoto(onSuccess: @escaping (UIImage?) -> Void, onFailure: @escaping (Error) -> Void)
    func removeUserPhoto(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func updateUserPhoto(_ photo: UIImage, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}

enum SessionSate {
    case login
    case logout
    case changePhoto
}

protocol SessionSatePublisherProtocol {
    var sessionSatePublisher: AnyPublisher<SessionSate, Never> { get }
}

final class UserSession: SessionSatePublisherProtocol {
    
    // MARK: - Public properties
    
    static let shared = UserSession()
    
    var sessionSatePublisher: AnyPublisher<SessionSate, Never> {
        sessionSateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private properties
    
    private var _userInfo: UserInfoProtocol & UserInfoChangeStateProtocol
    private let userProfile: UserProfileExtandableProtocol
    private let mediaDownloader: MediaDownloadableProtocol
    private let storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol
    private let sessionSateSubject: PassthroughSubject<SessionSate, Never>
    
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
        self.sessionSateSubject = .init()
        
        self.setupUserInfoChangeStateNotifications()
    }
    
    // MARK: - Private methods
    
    private func setupUserInfoChangeStateNotifications() {
        _userInfo.didUserLoginHandler = {
            self.sessionSateSubject.send(.login)
        }
        _userInfo.didUserLogoutHandler = {
            self.clearUserMetaData()
            self.sessionSateSubject.send(.logout)
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
    
    func getUserPhoto(onSuccess: @escaping (UIImage?) -> Void, onFailure: @escaping (Error) -> Void) {
        if let data = userDefaults.data(forKey: UserDefaultsKey.userImage.rawValue) {
            onSuccess(UIImage(data: data))
        } else {
            if networkState.isReachable, let photoURL = _userInfo.photoURL {
                mediaDownloader.downloadMedia(url: photoURL, onSucces: { (data) in
                    self.userDefaults.set(data, forKey: UserDefaultsKey.userImage.rawValue)
                    onSuccess(UIImage(data: data))
                }, onFailure: onFailure)
            } else {
                onSuccess(nil)
            }
        }
    }
    
    func removeUserPhoto(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        if networkState.isReachable, let userId = _userInfo.id {
            let request = DeleteUserImageFirestoreRequest(userId: userId)
            storage.delete(request: request, onSuccess: {
                self.userProfile.removePhotoURL(onSuccess: {
                    self.userDefaults.removeObject(forKey: UserDefaultsKey.userImage.rawValue)
                    onSuccess()
                }, onFailure: onFailure)
            }, onFailure: onFailure)
        } else {
            onFailure(NetworkSatatError.isNotConnectionToTheInternet)
        }
    }
    
    func updateUserPhoto(_ image: UIImage, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        if networkState.isReachable, let userId = _userInfo.id, let data = image.jpegData(compressionQuality: 0.25) {
            let request = UserImageFirestoreRequest(userId: userId, imageData: data)
            storage.upload(request: request, onSuccess: { (photoURL) in
                self.userProfile.updatePhotoURL(photoURL, onSuccess: {
                    self.userDefaults.set(data, forKey: UserDefaultsKey.userImage.rawValue)
                    self.sessionSateSubject.send(.logout)
                    onSuccess()
                }, onFailure: onFailure)
            }, onFailure: onFailure)
        } else {
            onFailure(NetworkSatatError.isNotConnectionToTheInternet)
        }
    }
    
}
