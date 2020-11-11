//
//  BottomCardPresenter.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class BottomCardPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)!
        toView.layer.masksToBounds = true
        toView.layer.cornerRadius = 20
        
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        container.addSubview(toView)
        toView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
            toView.heightAnchor.constraint(equalToConstant: toViewController.preferredContentSize.height)
        ])
        
        container.layoutIfNeeded()
        
        let originalOriginY = toView.frame.origin.y
        toView.frame.origin.y += container.frame.height - toView.frame.minY
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            toView.frame.origin.y = originalOriginY
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
    
}
