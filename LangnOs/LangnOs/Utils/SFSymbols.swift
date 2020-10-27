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

struct SFSymbols {
    
    static func bookmark(for state: ImageState) -> UIImage {
        switch state {
        case .normal:
            return UIImage(systemName: "bookmark")!
        case .fill:
            return UIImage(systemName: "bookmark.fill")!
        }
    }
    
    static func personCircle() -> UIImage {
        return UIImage(systemName: "person.circle")!
    }
    
    static func more() -> UIImage {
        return UIImage(systemName: "ellipsis")!
    }
    
    static func edit() -> UIImage {
        return UIImage(systemName: "pencil")!
    }
    
    static func reset() -> UIImage {
        return UIImage(systemName: "arrow.clockwise")!
    }
    
    static func statistic() -> UIImage {
        return UIImage(systemName: "chart.pie")!
    }
    
    static func meterials() -> UIImage {
        return UIImage(systemName: "square.grid.2x2")!
    }
    
    static func book() -> UIImage {
        return UIImage(systemName: "book")!
    }
    
    static func planet() -> UIImage {
        return UIImage(systemName: "globe")!
    }
    
    static func heart(for state: ImageState) -> UIImage {
        switch state {
        case .normal:
            return UIImage(systemName: "heart")!
        case .fill:
            return UIImage(systemName: "heart.fill")!
        }
    }
    
}
