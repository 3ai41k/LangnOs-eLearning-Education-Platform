//
//  SecurityManager.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 16.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

protocol SessionInfoProtocol {
    var userId: String? { get }
    var username: String? { get }
    var email: String? { get }
    var photoURL: URL? { get }
}

protocol ProfileExtandableProtocol {
    func updatePhotoURL(_ url: URL, completion: @escaping (Error?) -> Void)
    func removePhotoURL(completion: @escaping (Error?) -> Void)
}

enum UserSessionState {
    case didUserLogin
    case didUserLogout
}

protocol SessionStatePublisherProtocol {
    var sessionStatePublisher: AnyPublisher<UserSessionState, Never> { get }
}

final class UserSession {
    
    // MARK: - Public properties
    
    static let shared = UserSession()
    
    // MARK: - Private properties
    
    private var auth: Auth {
        Auth.auth()
    }
    
    private let sessionStateSubject = PassthroughSubject<UserSessionState, Never>()
    
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!
    
    // MARK: - Init
    
    init() {
        self.setupNotifications()
    }
    
    deinit {
        self.removeNotifications()
    }
    
    // MARK: - Private methods
    
    private func setupNotifications() {
        authStateDidChangeListenerHandle = auth.addStateDidChangeListener { [weak self] (_, user) in
            if let _ = user {
                self?.sessionStateSubject.send(.didUserLogin)
            } else {
                self?.sessionStateSubject.send(.didUserLogout)
            }
        }
    }
    
    private func removeNotifications() {
        auth.removeStateDidChangeListener(authStateDidChangeListenerHandle)
    }
    
}

// MARK: - SessionInfoProtocol

extension UserSession: SessionInfoProtocol {
    
    var userId: String? {
        auth.currentUser?.uid
    }
    
    var email: String? {
        auth.currentUser?.email
    }
    
    var username: String? {
        auth.currentUser?.displayName
    }
    
    var photoURL: URL? {
        auth.currentUser?.photoURL
    }
    
}

// MARK: - ProfileExtandableProtocol

extension UserSession: ProfileExtandableProtocol {
    
    func updatePhotoURL(_ url: URL, completion: @escaping (Error?) -> Void) {
        changePhotoURL(url, completion: completion)
    }
    
    func removePhotoURL(completion: @escaping (Error?) -> Void) {
        changePhotoURL(nil, completion: completion)
    }
    
    private func changePhotoURL(_ url: URL?, completion: @escaping (Error?) -> Void) {
        let request = auth.currentUser?.createProfileChangeRequest()
        request?.photoURL = url
        request?.commitChanges(completion: { (error) in
            completion(error)
        })
    }
    
}

// MARK: - SessionStatePublisherProtocol

extension UserSession: SessionStatePublisherProtocol {
    
    var sessionStatePublisher: AnyPublisher<UserSessionState, Never> {
        sessionStateSubject.eraseToAnyPublisher()
    }
    
}
