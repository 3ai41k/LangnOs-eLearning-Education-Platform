//___FILEHEADER___

import UIKit

protocol ___FILEBASENAMEASIDENTIFIER___NavigationProtocol {
    
}

typealias ___FILEBASENAMEASIDENTIFIER___Protocol =
    ___FILEBASENAMEASIDENTIFIER___NavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class ___FILEBASENAMEASIDENTIFIER___: Coordinator  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel =
        let viewController = 
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
}

// MARK: - ___FILEBASENAMEASIDENTIFIER___NavigationProtocol

extension ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___NavigationProtocol {
    
}


