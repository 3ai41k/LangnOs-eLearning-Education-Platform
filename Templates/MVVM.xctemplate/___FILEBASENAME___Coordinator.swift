//___FILEHEADER___

import UIKit

protocol ___FILEBASENAMEASIDENTIFIER___NavigationProtocol {
    
}

typealias ___FILEBASENAMEASIDENTIFIER___Protocol =
    ___FILEBASENAMEASIDENTIFIER___NavigationProtocol &
    CoordinatorClosableProtocol &
    ActivityPresentableProtocol &
    AlertPresentableProtocol
    

final class ___FILEBASENAMEASIDENTIFIER___: Coordinator, ___FILEBASENAMEASIDENTIFIER___Protocol  {
    
    // MARK: - Override
    
    override func start() {
        let viewModel = ___VARIABLE_productName:identifier___ViewModel()
        let viewController = ___VARIABLE_productName:identifier___ViewController()
        viewController.viewModel = viewModel
        
        self.viewController = viewController
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
}


