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
    @Published var months = [[Day]]()
    @Published var section = ""

    @Published var page = 0 {
        didSet { update() }
    }
    

    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
    
    var transition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        
        return .asymmetric(insertion: insertion, removal: removal)
    }

    
    // MARK: Private
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.format13.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter
    }()
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        guard let startDate = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2021, month: 1, day: 1)),
              let endDate = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2021, month: 12, day: 31)) else { return }
        
        var months = [[Day]]()
        var section = ""
        
        for year in startDate.year...endDate.year {
            for month in startDate.month...endDate.month {
                guard let date = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: year, month: month, day: 1)), var firstDate = date.firstDate, var lastDate = date.lastDate else {
                    log(.error, "Failed to get a date. \(year). \(month)")
                    continue
                }
                
                section = dateFormatter.string(from: startDate)

                // Previous month
                let weekDay = firstDate.weekDay
                if 1 < weekDay, let previousMonth = firstDate.date(days: -Int(weekDay - 1)) {
                    firstDate = previousMonth
                }
                
                guard let totalDays = lastDate.days(from: firstDate) else {
                    log(.error, "Failed to get a totalDays.")
                    return
                }
                
                if totalDays < 41, let date = lastDate.date(days: 41 - totalDays) {
                    lastDate = date
                }
                
                var days = [Day(date: firstDate, validDate: date)]
                while firstDate < lastDate {
                    guard let next = firstDate.date(days: 1) else {
                        log(.error, "Failed to get a date. firstDate: \(firstDate), lastDate:\(lastDate)")
                        break
                    }
                    
                    firstDate = next
                    days.append(Day(date: next, validDate: date))
                }
                
                months.append(days)
            }
        }
        
        DispatchQueue.main.async {
            self.months  = months
            self.section = section
        }
    }
    
    func update(data: Day) {
        /*
        guard let index = days.firstIndex(where: { $0 == data }) else {
            log(.error, "Failed to the clicked day.")
            return
        }
        
        days[index].isSelected.toggle()
         */
    }
    

    // MARK: Private
    private func update() {
        guard page < months.count, let date = months[page].first?.validDate else { return }
        withAnimation {
            section = dateFormatter.string(from: date)
        }
    }
}
