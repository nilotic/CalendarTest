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
    @Published var dates = [Date]()
    
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
                   GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    let dateFormatter = ISO8601DateFormatter()
    
    // MARK: - Function
    // MARK: Public
    func request() {
        guard var date = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2021, month: 7, day: 1)), var firstDate = date.firstDate, let lastDate = date.lastDate else { return }
        let weekDay = firstDate.weekDay
        
        if 1 < weekDay, let previousMonthWeekDay = firstDate.date(days: -Int(weekDay - 1)) {
            firstDate = previousMonthWeekDay
        }
        
        var dates = [firstDate]
        while firstDate < lastDate {
            guard let next = firstDate.date(days: 1) else {
                log(.error, "Failed to get a date. date: \(firstDate),  last:\(lastDate)")
                break
            }
            
            firstDate = next
            dates.append(next)
        }
        
        DispatchQueue.main.async { self.dates = dates }
    }
}
