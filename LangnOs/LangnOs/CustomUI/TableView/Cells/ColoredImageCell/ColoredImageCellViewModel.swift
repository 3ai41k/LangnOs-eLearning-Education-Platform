//
//  ColoredImageCellViewModel.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

protocol ColoredImageCellViewModelInput {
    var text: String { get }
    var image: UIImage { get }
    var color: UIColor { get }
}

typealias ColoredImageCellViewModelProtocol =
    CellViewModelProtocol &
    ColoredImageCellViewModelInput

final class ColoredImageCellViewModel: ColoredImageCellViewModelProtocol {
    
    var text: String
    var image: UIImage
    var color: UIColor
    
    init(text: String, image: UIImage, color: UIColor) {
        self.text = text
        self.image = image
        self.color = color
    }
    
}
