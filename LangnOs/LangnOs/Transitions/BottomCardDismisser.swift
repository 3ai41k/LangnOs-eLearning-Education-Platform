//
//  BottomCardDismisser.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 24.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class BottomCardDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        UIView.animate(withDuration: 0.2, animations: {
            fromView.frame.origin.y += container.frame.height - fromView.frame.minY
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
    
}
