//
//  SFSymbolsImage.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 23.10.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import UIKit

enum ImageState {
    case normal
    case fill
}

struct SFSymbolsImage {
    
    static func bookmark(for state: ImageState) -> UIImage {
        switch state {
        case .normal:
            return UIImage(systemName: "bookmark")!
        case .fill:
            return UIImage(systemName: "bookmark.fill")!
        }
    }
    
}
