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
        if let username = userSession.currentUser?.name {
            return username
        } else {
            return "Anonim".localize
        }
    }
    
    var email: String {
        if let email = userSession.currentUser?.email {
            return email
        } else {
            return "_______@____.___".localize
        }
    }
    
    var tableSections: [SectionViewModelProtocol] = []
    
    // MARK: - Private properties
    
    private let router: AccountCoordinatorProtocol
    private let userSession: SessionInfoProtocol & SessionLifecycleProtocol
    private let storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol
    
    // MARK: - Init
    
    init(router: AccountCoordinatorProtocol,
         userSession: SessionInfoProtocol & SessionLifecycleProtocol,
         storage: FirebaseStorageUploadingProtocol & FirebaseStorageRemovingProtocol) {
        self.router = router
        self.userSession = userSession
        self.storage = storage
        
        self.userPhoto = .init(nil)
        
        self.setupEmptySection()
        self.setupMainSettinsSection()
        self.setupFeedbackSection()
        self.setupLogoutSection()
        
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
        userPhoto.value = SFSymbols.personCircle()
    }
    
    private func setupEmptySection() {
        let sectionViewModel = TableSectionViewModel(cells: [])
        tableSections.append(sectionViewModel)
    }
    
    private func setupMainSettinsSection() {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Appearance", image: SFSymbols.apperance(), color: .systemGray3, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "App Icon", image: SFSymbols.photo(), color: .systemGray3, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "App Language", image: SFSymbols.planet(), color: .systemGray3, accessoryType: .disclosureIndicator),
            ColoredImageCellViewModel(text: "Push Notifications", image: SFSymbols.bell(for: .normal), color: .systemGray3, accessoryType: .disclosureIndicator)
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupFeedbackSection() {
        let cellViewModels = [
            ColoredImageCellViewModel(text: "Share Feedback", image: SFSymbols.feedback(), color: .systemGray3, accessoryType: .disclosureIndicator)
        ]
        let sectionViewModel = TableSectionViewModel(cells: cellViewModels)
        tableSections.append(sectionViewModel)
    }
    
    private func setupLogoutSection() {
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
            self.userPhoto.value = image
        }
    }
    
    private func removeImageAction() {
        userPhoto.value = nil
    }
    
    private func logoutAction() {
        router.showAlert(title: "Are you sure?", message: nil, actions: [
            CancelAlertAction(handler: { }),
            OkAlertAction(handler: {
                self.userSession.finishSession()
                self.router.close()
            })
        ])
    }
    
}

