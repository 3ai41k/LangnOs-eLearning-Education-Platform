//
//  AlertPresentableProtocol.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 07.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol AlertPresentableProtocol {
    func showAlert(title: String?, message: String?, actions: [UIAlertAction])
}

extension AlertPresentableProtocol where Self: Coordinator {
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach({ alertController.addAction($0) })
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
}

final class OkAlertAction: UIAlertAction {
    
    convenience init(handler: @escaping () -> Void) {
        self.init(title: "OK".localize, style: .default) { (_) in
            handler()
        }
    }
    
}

final class CancelAlertAction: UIAlertAction {
    
    convenience init(handler: (() -> Void)?) {
        self.init(title: "Cancle".localize, style: .default) { (_) in
            handler?()
        }
    }
    
}
