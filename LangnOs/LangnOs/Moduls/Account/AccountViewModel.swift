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
        if let username = userSession.userInfo.name {
            return username
        } else {
            return "Anonim".localize
        }
    }
    
    var email: String {
        if let email = userSession.userInfo.email {
            return email
        } else {
            return "_______@____.___".localize
        }
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: AccountCoordinatorProtocol
    private let authorizator: LogOutableProtocol
    private let userSession: SessionInfoProtocol
    private let storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol
    
    // MARK: - Init
    
    init(router: AccountCoordinatorProtocol,
         authorizator: LogOutableProtocol,
         userSession: SessionInfoProtocol,
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
            TakePhotoAlertAction(handler: selectImageAction),
            PhotoLibraryAlertAction(handler: selectImageAction),
            RemovePhotoAlertAction(handler: removeImageAction),
            CancelAlertAction(handler: { })
        ])
    }
    
    // MARK: - Private methods
    
    private func downloadUserPhoto() {
        userSession.getUserPhoto { (image) in
            self.userPhoto.value = image != nil ? image : SFSymbols.personCircle()
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
    
    private func selectImageAction() {
        router.navigateToImagePicker(sourceType: .photoLibrary) { (image) in
            self.userPhoto.value = nil
            self.userSession.updateUserPhoto(image) {
                self.userPhoto.value = image
            }
        }
    }
    
    private func removeImageAction() {
        userPhoto.value = nil
        userSession.removeUserPhoto {
            self.userPhoto.value = SFSymbols.personCircle()
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

