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
    func showActionSheet(title: String?, message: String?, actions: [UIAlertAction])
    func showError(_ error: Error)
}

extension AlertPresentableProtocol where Self: Coordinator {
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        show(title: title, message: message, actions: actions, preferredStyle: .alert)
    }
    
    func showActionSheet(title: String?, message: String?, actions: [UIAlertAction]) {
        show(title: title, message: message, actions: actions, preferredStyle: .actionSheet)
    }
    
    func showError(_ error: Error) {
        show(title: "Error!".localize, message: error.localizedDescription, actions: [
            OkAlertAction(handler: { })
        ], preferredStyle: .alert)
    }
    
    private func show(title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
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
        self.init(title: "Cancel".localize, style: .cancel) { (_) in
            handler?()
        }
    }
    
}

final class SingInAlertAction: UIAlertAction {
    
    convenience init(handler: (() -> Void)?) {
        self.init(title: "Sing In".localize, style: .default) { (_) in
            handler?()
        }
    }
    
}

final class RenameAlertAction: UIAlertAction {
    
    convenience init(handler: (() -> Void)?) {
        self.init(title: "Rename".localize, style: .default) { (_) in
            handler?()
        }
    }
    
}

final class TakePhotoAlertAction: UIAlertAction {
    
    convenience init(handler: (() -> Void)?) {
        self.init(title: "Take photo".localize, style: .default) { (_) in
            handler?()
        }
    }
    
}

final class CameraRollAlertAction: UIAlertAction {
    
    convenience init(handler: (() -> Void)?) {
        self.init(title: "Camera roll".localize, style: .default) { (_) in
            handler?()
        }
    }
    
}

final class PhotoLibraryAlertAction: UIAlertAction {
    
    convenience init(handler: (() -> Void)?) {
        self.init(title: "Photo library".localize, style: .default) { (_) in
            handler?()
        }
    }
    
}

final class RemovePhotoAlertAction: UIAlertAction {
    
    convenience init(handler: (() -> Void)?) {
        self.init(title: "Remove photo".localize, style: .destructive) { (_) in
            handler?()
        }
    }
    
}

