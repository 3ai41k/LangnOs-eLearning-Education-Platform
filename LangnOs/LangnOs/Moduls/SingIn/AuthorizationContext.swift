//
//  AuthorizationContext.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 09.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation
import Combine

protocol SingUpPublisherContextProtocol {
    var singUpPublisher: AnyPublisher<Void, Never> { get }
}

protocol SingUpContextProtocol {
    func userDidCreated()
}

protocol AuthorizationContextProtocol: SingUpPublisherContextProtocol, SingUpContextProtocol {
    
}

final class AuthorizationContext: AuthorizationContextProtocol {
    
    // MARK: - Private properties
    
    private let singUpSubject: PassthroughSubject<Void, Never>
    
    // MARK: - Public properties
    
    var singUpPublisher: AnyPublisher<Void, Never> {
        singUpSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    init() {
        singUpSubject = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Public methods
    
    func userDidCreated() {
        singUpSubject.send()
    }
    
}
