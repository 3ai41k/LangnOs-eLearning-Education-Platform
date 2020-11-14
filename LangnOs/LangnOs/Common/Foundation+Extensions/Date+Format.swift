//
//  Date+Format.swift
//  LangnOs
//
//  Created by Nikita Lizogubov on 14.11.2020.
//  Copyright © 2020 NL. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    case MMddyyyy = "MM.dd.yyyy"
    case MMddyyyyHHmm = "MM.dd.yyyy HH:mm a"
    case HHmm = "HH:mm a"
}

extension Date {
    
    func format(type: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }

}
