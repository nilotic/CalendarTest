//
//  Day.swift
//  Calendar
//
//  Created by Den Jo on 2021/07/08.
//

import SwiftUI

struct Day {
    let month: UInt
    let date: Date
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
        date.month != month ? 0.48 : 1
    }
}

extension Day: Identifiable {
    
    var id: String {
        "\(month)\(date)\(isSelected)"
    }
}

extension Day: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Day: Equatable {
    
    static func ==(lhs: Day, rhs: Day) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension Day {
    
    static var placeholder: Day {
        Day(month: 7, date: Date(), isSelected: true)
    }
}
#endif
