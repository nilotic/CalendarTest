//
//  Day.swift
//  Calendar
//
//  Created by Den Jo on 2021/07/08.
//

import SwiftUI

struct Day {
    let date: Date
    let validDate: Date
    var isSelected = false
}

extension Day {
    
    var color: Color {
        switch date.weekDay {
        case 1:     return .red
        case 7:     return .blue
        default:    return .white
        }
    }
    
    var opacity: Double {
        date.month != validDate.month ? 0.48 : 1
    }
    
    var isValid: Bool {
        date.month == validDate.month
    }
}

extension Day: Identifiable {
    
    var id: String {
        "\(validDate)\(date)\(isSelected)"
    }
}

extension Day: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Day: Equatable {
    
    static func ==(lhs: Day, rhs: Day) -> Bool {
        lhs.date == rhs.date && lhs.validDate == rhs.validDate
    }
}

#if DEBUG
extension Day {
    
    static var placeholder: Day {
        Day(date: Date(), validDate: Date(), isSelected: true)
    }
}
#endif
