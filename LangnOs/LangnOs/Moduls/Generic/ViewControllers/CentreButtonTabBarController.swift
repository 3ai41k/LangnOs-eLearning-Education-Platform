//
//  CentreButtonTabBarController.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 22.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

extension UIView {
    
    func addFillSubview(_ view: UIView) {
        addFillSubview(view, insets: .zero)
    }
    
    func addFillSubview(_ view: UIView, insets: UIEdgeInsets) {
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }
    
}

struct CentreButtonBarButtonItem {
    var title: String?
    var selectedImage: UIImage?
    var unselectedImage: UIImage?
}

protocol CentreButtonTabBarControllerDelegate: class {
    func centreButtonTabBarControllerfor(_ centreButtonTabBarControllerfor: CentreButtonTabBarController, didCentreButtonTouchFor viewController: UIViewController)
}

class CentreButtonTabBarController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: CentreButtonTabBarControllerDelegate?
    
    var viewControllers: [UIViewController] = [] {
        didSet {
            setupTabBarItems()
            bringViewControllerToFront(viewControllers.first!)
        }
    }
    
    // MARK: - Private properties
    
    private var containerView: UIView = {
        UIView()
    }()
    private var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 96.0).isActive = true
        return view
    }()
    private var tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()
    private var centreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 32.0
        button.translatesAutoresizingMaskIntoConstraints = false
        // Dengerous moment (retain cycle) FIX IT
        button.addTarget(self, action: #selector(didCentreButtonTouch), for: .touchUpInside)
        return button
    }()
    
    private var selectedIndex: Int = 0
    
    // MARK: - Lifecycle
    
    override func loadView() {
        bottomContainerView.addFillSubview(tabBarStackView, insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 16.0, right: 8.0))
        
        let stackView = UIStackView(arrangedSubviews: [
            containerView,
            bottomContainerView
        ])
        stackView.axis = .vertical
        
        stackView.addSubview(centreButton)
        NSLayoutConstraint.activate([
            centreButton.heightAnchor.constraint(equalToConstant: 64.0),
            centreButton.widthAnchor.constraint(equalToConstant: 64.0),
            centreButton.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 32.0),
            centreButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor)
        ])
        
        view = stackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewControllers = CentreButtonTabBarController.mockViewControllers
    }
    
    // MARK: - Init
    // MARK: - Override
    // MARK: - Public methods
    // MARK: - Private methods
    
    private func setupTabBarItems() {
        viewControllers.enumerated().forEach({ index, viewController in
            
            let button = UIButton()
            button.tag = index
            button.backgroundColor = .green
            button.setTitle("Test", for: .normal)
            button.setImage(UIImage(systemName: "book.fill"), for: .normal)
            button.setImage(UIImage(systemName: "book"), for: .selected)
            button.addTarget(self, action: #selector(didTapBarTouch), for: .touchUpInside)
            
            self.tabBarStackView.addArrangedSubview(button)
        })
    }
    
    private func bringViewControllerToFront(_ viewController: UIViewController) {
        containerView.addFillSubview(viewController.view)
        didMove(toParent: viewController)
    }
    
    private func removeViewControllerFromFront(_ viewController: UIViewController) {
        viewController.view.removeFromSuperview()
    }
    
    // MARK: - Actions
    
    @objc
    private func didCentreButtonTouch() {
        let currentViewController = viewControllers[selectedIndex]
        delegate?.centreButtonTabBarControllerfor(self, didCentreButtonTouchFor: currentViewController)
    }
    
    @objc
    private func didTapBarTouch(_ sender: UIButton) {
        let index = sender.tag
        
        let oldViewController = viewControllers[selectedIndex]
        let newViewController = viewControllers[index]
        
        selectedIndex = index
        
        removeViewControllerFromFront(oldViewController)
        bringViewControllerToFront(newViewController)
    }
    
}
