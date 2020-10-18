//
//  AccountViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

enum AccountViewModelAction {
    case downloadUserImage
}

protocol AccountInputProtocol: NavigatableViewModelProtocol {
    var initials: CurrentValueSubject<String?, Never> { get }
    var email: CurrentValueSubject<String?, Never> { get }
    var userImage: CurrentValueSubject<UIImage?, Never> { get }
    var isImageActivityIndicatorHidden: CurrentValueSubject<Bool, Never> { get }
}

protocol AccountOutputProtocol {
    var actionSubject: PassthroughSubject<AccountViewModelAction, Never> { get }
}

protocol AccountBindingProtocol {
    var reloadUI: AnyPublisher<Void, Never> { get }
}

typealias AccountViewModelProtocol =
    AccountInputProtocol &
    AccountOutputProtocol &
    AccountBindingProtocol

final class AccountViewModel: AccountOutputProtocol {
    
    // MARK: - Public properties
    
    var initials: CurrentValueSubject<String?, Never>
    var email: CurrentValueSubject<String?, Never>
    var userImage: CurrentValueSubject<UIImage?, Never>
    var isImageActivityIndicatorHidden: CurrentValueSubject<Bool, Never>
    
    var actionSubject = PassthroughSubject<AccountViewModelAction, Never>()
    
    // MARK: - Private properties
    
    private let router: AccountCoordinatorProtocol
    private let context: SingInPublisherContextProtocol & UserSessesionContextProtocol
    private let securityManager: SecurityManager
    private let storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol
    private let authorizator: LoginableProtocol & UserProfileExtandableProtocol
    
    private var actionPublisher: AnyPublisher<AccountViewModelAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    private var reloadUISubject = PassthroughSubject<Void, Never>()
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(router: AccountCoordinatorProtocol,
         context: SingInPublisherContextProtocol & UserSessesionContextProtocol,
         securityManager: SecurityManager,
         storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol,
         authorizator: LoginableProtocol & UserProfileExtandableProtocol) {
        self.router = router
        self.context = context
        self.securityManager = securityManager
        self.storage = storage
        self.authorizator = authorizator
        
        self.initials = .init(securityManager.user?.displayName ?? "No name".localize)
        self.email = .init(securityManager.user?.email)
        self.userImage = .init(nil)
        self.isImageActivityIndicatorHidden = .init(false)
        
        bindContext()
        bindView()
    }
    
    // MARK: - Private methods
    
    private func bindContext() {
        context.userSingInPublisher.sink { [weak self] (user) in
            self?.securityManager.setUser(user)
            self?.router.navigateToPresention()
            
            self?.initials.value = user.displayName ?? "No name".localize
            self?.email.value = user.email
            self?.dowloadUserImage()
            
            self?.reloadUISubject.send()
        }.store(in: &cancellables )
    }
    
    private func bindView() {
        actionPublisher.sink { [weak self] (action) in
            switch action {
            case .downloadUserImage:
                self?.dowloadUserImage()
            }
        }.store(in: &cancellables)
    }
    
    private func logout() {
        authorizator.logOut { (error) in
            if let error = error {
                self.router.showError(error)
            } else {
                self.securityManager.removeUser()
                self.context.removeUserFromCurrentSession()
                
                self.initials.value = "No name".localize
                self.email.value = nil
                self.userImage.value = Constants.defaultImage
                
                self.reloadUISubject.send()
            }
        }
    }
    
    private func didImageSelect(_ image: UIImage) {
        guard let user = securityManager.user else { return }
        
        let request = UserImageFirestoreRequest(user: user, image: image, compressionQuality: 0.5)
        storage.upload(request: request) { (result) in
            switch result {
            case .success(let url):
                self.authorizator.setImage(url: url) { (error) in
                    if let error = error {
                        self.router.showError(error)
                    } else {
                        self.userImage.value = image
                    }
                }
            case .failure(let error):
                self.router.showError(error)
            }
        }
    }
    
    private func dowloadUserImage() {
        guard userImage.value == nil else { return }
        if let photoURL = securityManager.user?.photoURL {
            DispatchQueue.global(qos: .utility).async {
                do {
                    let data = try Data(contentsOf: photoURL)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.userImage.value = image
                            self.isImageActivityIndicatorHidden.value = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.router.showError(error)
                        self.isImageActivityIndicatorHidden.value = true
                    }
                }
            }
        } else {
            userImage.value = Constants.defaultImage
            isImageActivityIndicatorHidden.value = true
        }
    }
    
    private func removeUserImage() {
        guard let user = securityManager.user else { return }
        
        let request = DeleteUserImageFirestoreRequest(user: user)
        storage.delete(request: request) { (error) in
            if let error = error {
                self.router.showError(error)
            } else {
                self.authorizator.removeImage { (error) in
                    if let error = error {
                        self.router.showError(error)
                    } else {
                        self.userImage.value = Constants.defaultImage
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didSingInTouch() {
        router.navigateToSingIn()
    }
    
    @objc
    private func didLogoutTouch() {
        router.showAlert(title: "Are you sure?".localize, message: nil, actions: [
            CancelAlertAction(handler: { }),
            OkAlertAction(handler: logout)
        ])
    }
    
    @objc
    private func didEditProfileTouch() {
        router.showActionSheet(title: nil, message: nil, actions: [
            RenameAlertAction(handler: {
                
            }),
            TakePhotoAlertAction(handler: {
                self.router.navigateToImagePicker(sourceType: .camera, didImageSelect: self.didImageSelect)
            }),
            CameraRollAlertAction(handler: {
                self.router.navigateToImagePicker(sourceType: .savedPhotosAlbum, didImageSelect: self.didImageSelect)
            }),
            PhotoLibraryAlertAction(handler: {
                self.router.navigateToImagePicker(sourceType: .photoLibrary, didImageSelect: self.didImageSelect)
            }),
            RemovePhotoAlertAction(handler: {
                self.removeUserImage()
            }),
            CancelAlertAction(handler: { })
        ])
    }
    
}

// MARK: - AccountInputProtocol

extension AccountViewModel: AccountInputProtocol {
    
    var navigationItemDrivableModel: DrivableModelProtocol {
        let singInBarButton = BarButtonDrivableModel(title: "Sing In".localize,
                                                     style: .done,
                                                     target: self,
                                                     selector: #selector(didSingInTouch))
        let logoutBarButton = BarButtonDrivableModel(title: "Log out".localize,
                                                     style: .done,
                                                     target: self,
                                                     selector: #selector(didLogoutTouch))
        let editBarBuuton = BarButtonDrivableModel(title: "Edit",
                                                   style: .plain,
                                                   target: self,
                                                   selector: #selector(didEditProfileTouch))
        let leftBarButtons = securityManager.user != nil ? [editBarBuuton] : []
        let rightBarButtons = securityManager.user != nil ? [logoutBarButton] : [singInBarButton]
        return NavigationItemDrivableModel(title: nil,
                                           leftBarButtonDrivableModels: leftBarButtons,
                                           rightBarButtonDrivableModels: rightBarButtons)
    }
    
    var navigationBarDrivableModel: DrivableModelProtocol? {
        NavigationBarDrivableModel(isBottomLineHidden: true,
                                   backgroundColor: ColorUtils.app,
                                   prefersLargeTitles: false)
    }
    
}

// MARK: - AccountBindingProtocol

extension AccountViewModel: AccountBindingProtocol {
    
    var reloadUI: AnyPublisher<Void, Never> {
        reloadUISubject.eraseToAnyPublisher()
    }
    
}

// MARK: - Constants

extension AccountViewModel {
    
    enum Constants {
        static let defaultImage = UIImage(systemName: "person.crop.circle")!
    }
    
}

