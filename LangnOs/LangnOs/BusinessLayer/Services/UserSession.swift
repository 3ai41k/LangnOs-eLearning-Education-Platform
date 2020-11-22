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
    func start(with user: User1)
    func saveChanges()
    func finish()
}

enum SessionState {
    case start
    case finish
}

protocol SessionStateProtocol {
    var sessionState: AnyPublisher<SessionState, Never> { get }
}

final class UserSession: SessionInfoProtocol {
    
    // MARK: - Public properties
    
    static let shared = UserSession()
    
    private(set) var currentUser: User1?
    
    // MARK: - Private properties
    
    private var coreDataStack: CoreDataClearableProtocol {
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
                sessionStateeSubject.send(.start)
            } catch {
                print(self, "decoding error: ", error.localizedDescription)
            }
        }
    }
    
}

// MARK: - SessionLifecycleProtocol

extension UserSession: SessionLifecycleProtocol {
    
    func start(with user: User1) {
        do {
            let data = try JSONEncoder().encode(user)
            userDefaults.set(data, forKey: UserDefaultsKey.user.rawValue)
            currentUser = user
            sessionStateeSubject.send(.start)
        } catch {
            print(self, "encoding error: ", error.localizedDescription)
        }
    }
    
    func saveChanges() {
        guard let currentUser = currentUser else { return }
        do {
            let data = try JSONEncoder().encode(currentUser)
            userDefaults.set(data, forKey: UserDefaultsKey.user.rawValue)
        } catch {
            print(self, "encoding error: ", error.localizedDescription)
        }
    }
    
    func finish() {
        userDefaults.removeObject(forKey: UserDefaultsKey.user.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKey.userImage.rawValue)
        coreDataStack.clear()
        currentUser = nil
        sessionStateeSubject.send(.finish)
    }
    
}

// MARK: - SessionStateProtocol

extension UserSession: SessionStateProtocol {
    
    var sessionState: AnyPublisher<SessionState, Never> {
        sessionStateeSubject.eraseToAnyPublisher()
    }
    
}
