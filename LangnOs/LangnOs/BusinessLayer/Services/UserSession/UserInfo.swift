//
//  UserInfo.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 04.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserInfoProtocol {
    var isLogin: Bool { get }
    var id: String? { get }
    var name: String? { get }
    var email: String? { get }
    var phone: String? { get }
    var photoURL: URL? { get }
}

protocol UserInfoChangeStateProtocol {
    var didNewUserLoginHandler: (() -> Void)? { get set }
    var didUserLogoutHandler: (() -> Void)? { get set }
}

final class UserInfo: UserInfoChangeStateProtocol {
    
    // MARK: - Private properties
    
    private var userStateHandeler: AuthStateDidChangeListenerHandle!
    
    private var auth: Auth {
        Auth.auth()
    }
    
    private var currentUser: User? {
        auth.currentUser
    }
    
    // MARK: - Public properties
    
    var didNewUserLoginHandler: (() -> Void)?
    var didUserLogoutHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    
    init() {
        setupUserStateNotification()
    }
    
    deinit {
        removeNotifications()
    }
    
    // MARK: - Private methods
    
    private func setupUserStateNotification() {
        userStateHandeler = auth.addStateDidChangeListener { [weak self] (auth, newUser) in
            if newUser == nil {
                self?.didUserLogoutHandler?()
            } else {
                self?.didNewUserLoginHandler?()
            }
        }
    }
    
    private func removeNotifications() {
        auth.removeStateDidChangeListener(userStateHandeler)
    }
    
}

// MARK: - UserInfoProtocol

extension UserInfo: UserInfoProtocol {
    
    var isLogin: Bool {
        currentUser != nil
    }
    
    var id: String? {
        currentUser?.uid
    }
    
    var name: String? {
        currentUser?.displayName
    }
    
    var email: String? {
        currentUser?.email
    }
    
    var phone: String? {
        currentUser?.phoneNumber
    }
    
    var photoURL: URL? {
        currentUser?.photoURL
    }
    
}
