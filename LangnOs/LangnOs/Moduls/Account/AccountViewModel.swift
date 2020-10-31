//
//  AccountViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 08.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit
import Combine

protocol AccountInputProtocol {
    var title: String { get }
    var userPhoto: CurrentValueSubject<UIImage?, Never> { get }
    var username: String { get }
    var email: String { get }
}

protocol AccountOutputProtocol {
    func editPhoto()
}

typealias AccountViewModelProtocol =
    AccountInputProtocol &
    AccountOutputProtocol &
    UniversalTableViewModelProtocol

final class AccountViewModel: AccountViewModelProtocol {
    
    // MARK: - Public properties
    
    var title: String {
        "Account".localize
    }
    
    var userPhoto: CurrentValueSubject<UIImage?, Never>
    
    var username: String {
        if let username = userSession.username {
            return username
        } else {
            return "Anonim".localize
        }
    }
    
    var email: String {
        if let email = userSession.email {
            return email
        } else {
            return "_______@____.___".localize
        }
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: AccountCoordinatorProtocol
    private let authorizator: LogOutableProtocol
    private let userSession: SessionInfoProtocol & ProfileExtandableProtocol
    private let storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol
    
    // MARK: - Init
    
    init(router: AccountCoordinatorProtocol,
         authorizator: LogOutableProtocol,
         userSession: SessionInfoProtocol & ProfileExtandableProtocol,
         storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol) {
        self.router = router
        self.authorizator = authorizator
        self.userSession = userSession
        self.storage = storage
        
        self.userPhoto = .init(nil)
        
        self.setupEmptySection(&tableSections)
        self.setupMainSettinsSection(&tableSections)
        self.setupFeedbackSection(&tableSections)
        self.setupLogoutSection(&tableSections)
        
        self.downloadUserPhoto()
    }
    
    // MARK: - Public methods
    
    func editPhoto() {
        router.showActionSheet(title: nil, message: nil, actions: [
            TakePhotoAlertAction(handler: {
                self.router.navigateToImagePicker(sourceType: .photoLibrary, didImageSelect: self.selectImageAction)
            }),
            CameraRollAlertAction(handler: {
                self.router.navigateToImagePicker(sourceType: .camera, didImageSelect: self.selectImageAction)
            }),
            PhotoLibraryAlertAction(handler: {
                self.router.navigateToImagePicker(sourceType: .photoLibrary, didImageSelect: self.selectImageAction)
            }),
            RemovePhotoAlertAction(handler: {
                self.removeImageAction()
            }),
            CancelAlertAction(handler: { })
        ])
    }
    
    // MARK: - Private methods
    
    private func downloadUserPhoto() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKey.userImage.rawValue), let image = UIImage(data: data) {
            userPhoto.value = image
        } else {
            userPhoto.value = SFSymbols.personCircle()
        }
    }
    
    private func setupEmptySection(_ tableSections: inout [SectionViewModelProtocol]) {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func setupMainSettinsSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Appearance", image: SFSymbols.apperance(), color: .systemGray3, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "App Icon", image: SFSymbols.photo(), color: .systemGray3, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "App Language", image: SFSymbols.planet(), color: .systemGray3, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "Push Notifications", image: SFSymbols.bell(for: .normal), color: .systemGray3, accessoryType: .disclosureIndicator)
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupFeedbackSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Share Feedback", image: SFSymbols.feedback(), color: .systemGray3, accessoryType: .disclosureIndicator)
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupLogoutSection(_ tableSections: inout [SectionViewModelProtocol]) {
        let cellViewModels = [
            ButtonCellViewModel(title: "Log out", titleColor: .systemRed, buttonHandler: { [weak self] in
                self?.logoutAction()
            })
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    // MARK: - Actions
    
    private func selectImageAction(_ image: UIImage) {
        guard
            let userId = userSession.userId,
            let data = image.jpegData(compressionQuality: 0.25)
        else {
            return
        }
        
        userPhoto.value = nil
        
        let request = UserImageFirestoreRequest(userId: userId, data: data)
        storage.upload(request: request) { (result) in
            switch result {
            case .success(let photoURL):
                self.userSession.updatePhotoURL(photoURL) { (error) in
                    if let error = error {
                        self.router.showError(error)
                    } else {
                        UserDefaults.standard.set(data, forKey: UserDefaultsKey.userImage.rawValue)
                        self.userPhoto.value = image
                    }
                }
            case .failure(let error):
                self.router.showError(error)
            }
        }
    }
    
    private func removeImageAction() {
        guard let userId = userSession.userId else { return }
        
        userPhoto.value = nil
        
        let request = DeleteUserImageFirestoreRequest(userId: userId)
        storage.delete(request: request) { (error) in
            if let error = error {
                self.router.showError(error)
            } else {
                self.userSession.removePhotoURL { (error) in
                    if let error = error {
                        self.router.showError(error)
                    } else {
                        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userImage.rawValue)
                        self.userPhoto.value = SFSymbols.personCircle()
                    }
                }
            }
        }
    }
    
    private func logoutAction() {
        router.showAlert(title: "Are you sure?", message: nil, actions: [
            CancelAlertAction(handler: { }),
            OkAlertAction(handler: {
                self.authorizator.logOut(onSuccess: {
                    self.router.close()
                }) { (error) in
                    self.router.showError(error)
                }
            })
        ])
    }
    
}

