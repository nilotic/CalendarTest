//
//  CalendarData.swift
//  Calendar
//
//  Created by Den Jo on 2021/07/08.
//

import SwiftUI

final class CalendarData: ObservableObject {

    // MARK: - Value
    // MARK: Data
    @Published var days = [Day]()
    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        let month: UInt = 7
        
        guard let date = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2021, month: Int(month), day: 1)), var firstDate = date.firstDate, let lastDate = date.lastDate else { return }
        let weekDay = firstDate.weekDay
        
        if 1 < weekDay, let previousMonthWeekDay = firstDate.date(days: -Int(weekDay - 1)) {
            firstDate = previousMonthWeekDay
        }
        
        
        var days = [Day(month: month, date: firstDate)]
        while firstDate < lastDate {
            guard let next = firstDate.date(days: 1) else {
                log(.error, "Failed to get a date. date: \(firstDate),  last:\(lastDate)")
                break
            }
            
            firstDate = next
            days.append(Day(month: month, date: next))
        }
        
        DispatchQueue.main.async { self.days = days }
    }
    
    func update(data: Day) {
        guard let index = days.firstIndex(where: { $0 == data }) else {
            log(.error, "Failed to the clicked day.")
            return
        }
        
        days[index].isSelected.toggle()
    }
}
