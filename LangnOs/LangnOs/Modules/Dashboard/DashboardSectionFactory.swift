//
//  DashboardSectionFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class DashboardSectionFactory: SectionViewFactoryProtocol {
    
    func generateView(sectionViewModel: SectionViewViewModelProtocol) -> UIView {
        switch sectionViewModel {
        case let sectionViewModel as TitleSectionViewModel:
            guard let view: TitleSectionView = .fromNib() else { return UIView() }
            view.viewModel = sectionViewModel
            return view
        default:
            return UIView()
        }
    }
    
}
