//
//  AuthorizationContext.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 09.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
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

typealias AuthorizationContextProtocol = SingInPublisherContextProtocol & SingInContextProtocol & SingUpPublisherContextProtocol & SingUpContextProtocol

final class AuthorizationContext: AuthorizationContextProtocol {
    
    // MARK: - Private properties
    
    private let backToAuthorizeSubject: PassthroughSubject<Void, Never>
    private let userSingInSubject: PassthroughSubject<User, Never>
    
    // MARK: - Public properties
    
    var backToAuthorizePublisher: AnyPublisher<Void, Never> {
        backToAuthorizeSubject.eraseToAnyPublisher()
    }
    
    var userSingInPublisher: AnyPublisher<User, Never> {
        userSingInSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    init() {
        backToAuthorizeSubject = PassthroughSubject<Void, Never>()
        userSingInSubject = PassthroughSubject<User, Never>()
    }
    
    // MARK: - Public methods
    
    func userDidSingIn(_ user: User) {
        userSingInSubject.send(user)
    }
    
    func userDidCreate(_ user: User) {
        backToAuthorizeSubject.send()
        userSingInSubject.send(user)
    }
    
}
