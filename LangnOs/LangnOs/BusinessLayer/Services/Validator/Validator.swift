//
//  Validator.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 11.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

protocol EmailValidationProtocol {
    func isValid(email: String) -> Bool
}

final class Validator { }

// MARK: - EmailValidationProtocol

extension Validator: EmailValidationProtocol {
    
    func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
