//
//  DashboardSectionFactory.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

final class DashboardSectionFactory: SectionViewFactoryProtocol {
    
    func generateHederView(sectionViewModel: SectionViewViewModelProtocol) -> UIView {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: .zero, height: 44.0))
        view.backgroundColor = .red
        return view
    }
    
    func generateFooterView(sectionViewModel: SectionViewViewModelProtocol) -> UIView {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: .zero, height: 44.0))
        view.backgroundColor = .green
        return view
    }
    
}
