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
    var currentUser: User1? { get }
}

protocol SessionLifecycleProtocol {
    func starSession(with user: User1)
    func finishSession()
}

enum SessionState {
    case start
    case finish
}

protocol SessionSatePublisherProtocol {
    var sessionSatePublisher: AnyPublisher<SessionState, Never> { get }
}

final class UserSession: SessionInfoProtocol {
    
    // MARK: - Public properties
    
    static let shared = UserSession()
    
    private(set) var currentUser: User1? {
        didSet {
            currentUser != nil ?
                sessionStateeSubject.send(.start) :
                sessionStateeSubject.send(.finish)
        }
    }
    
    // MARK: - Private properties
    
    private var coreDataStack: CoreDataStack {
        CoreDataStack.shared
    }
    
    private var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    private let sessionStateeSubject: PassthroughSubject<SessionState, Never>
    
    // MARK: - Init
    
    private init() {
        self.sessionStateeSubject = .init()
        self.tryToSetupCurrentUser()
    }
    
    // MARK: - Private methods
    
    private func tryToSetupCurrentUser() {
        if let data = userDefaults.data(forKey: UserDefaultsKey.user.rawValue) {
            do {
                currentUser = try JSONDecoder().decode(User1.self, from: data)
            } catch {
                print(self, "decoding error: ", error.localizedDescription)
            }
        }
    }
    
}

// MARK: - SessionLifecycleProtocol

extension UserSession: SessionLifecycleProtocol {
    
    func starSession(with user: User1) {
        do {
            let data = try JSONEncoder().encode(user)
            userDefaults.set(data, forKey: UserDefaultsKey.user.rawValue)
            currentUser = user
        } catch {
            print(self, "encoding error: ", error.localizedDescription)
        }
    }
    
    func finishSession() {
        userDefaults.removeObject(forKey: UserDefaultsKey.user.rawValue)
        currentUser = nil
    }
    
}

// MARK: - SessionSatePublisherProtocol

extension UserSession: SessionSatePublisherProtocol {
    
    var sessionSatePublisher: AnyPublisher<SessionState, Never> {
        sessionStateeSubject.eraseToAnyPublisher()
    }
    
}
