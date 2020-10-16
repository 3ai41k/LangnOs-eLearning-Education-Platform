//
//  AuthorizationContext.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 09.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import FirebaseAuth
import Combine

protocol SingInPublisherContextProtocol {
    var userSingInPublisher: AnyPublisher<User, Never> { get }
}

protocol SingInContextProtocol {
    func userDidSingIn(_ user: User)
}

protocol SingUpPublisherContextProtocol {
    var backToAuthorizePublisher: AnyPublisher<Void, Never> { get }
}

protocol SingUpContextProtocol {
    func userDidCreate(_ user: User)
}

enum UserSessionState {
    case didSet(User)
    case didRemove
}

protocol UserSessesionPublisherContextProtocol {
    var userSessionPublisher: AnyPublisher<UserSessionState, Never> { get }
}

protocol UserSessesionContextProtocol {
    func setUserToCurrentSession(_ user: User)
    func removeUserFromCurrentSession()
}

typealias RootContextProtocol =
    SingInPublisherContextProtocol &
    SingInContextProtocol &
    SingUpPublisherContextProtocol &
    SingUpContextProtocol &
    UserSessesionPublisherContextProtocol &
    UserSessesionContextProtocol

final class RootContext: RootContextProtocol {
    
    // MARK: - Public properties
    
    var backToAuthorizePublisher: AnyPublisher<Void, Never> {
        backToAuthorizeSubject.eraseToAnyPublisher()
    }
    
    var userSingInPublisher: AnyPublisher<User, Never> {
        userSingInSubject.eraseToAnyPublisher()
    }
    
    var userSessionPublisher: AnyPublisher<UserSessionState, Never> {
        userSessionSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private properties
    
    private let backToAuthorizeSubject = PassthroughSubject<Void, Never>()
    private let userSingInSubject = PassthroughSubject<User, Never>()
    private let userSessionSubject = PassthroughSubject<UserSessionState, Never>()
    
    // MARK: - SingInContextProtocol
    
    func userDidSingIn(_ user: User) {
        userSingInSubject.send(user)
        setUserToCurrentSession(user)
    }
    
    // MARK: - SingUpContextProtocol
    
    func userDidCreate(_ user: User) {
        backToAuthorizeSubject.send()
        userDidSingIn(user)
    }
    
    // MARK: - UserSessesionContextProtocol
    
    func setUserToCurrentSession(_ user: User) {
        userSessionSubject.send(.didSet(user))
    }
    
    func removeUserFromCurrentSession() {
        userSessionSubject.send(.didRemove)
    }
    
}
