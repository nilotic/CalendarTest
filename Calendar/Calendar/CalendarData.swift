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
    @Published var weeks = [[Day]]()
    @Published var title = ""
    @Published var calendarHeight: CGFloat  = 60 * 6 + 1 * 5
    @Published var scrollOffset: CGPoint    = .zero
    @Published var calenderOffsetY: CGFloat = 0
    
    @Published var page = 0 {
        didSet { updateSection() }
    }
    
    let expandedHeight: CGFloat = 60 * 6 + 1 * 5
    let compactHeight: CGFloat  = 60
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)

    let startDate = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2021, month: 1, day: 1))
    let endDate   = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: 2021, month: 12, day: 31))

    var transition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    // MARK: Private
    private var lines: UInt = 6
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.format13.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter
    }()
    
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        guard let startDate = startDate, let endDate = endDate else { return }
        
        var weeks  = [[Day]]()
        var title = ""
        let lines = lines
        
        for year in startDate.year...endDate.year {
            for month in startDate.month...endDate.month {
                guard let date = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: year, month: month, day: 1)), var firstDate = date.firstDate, var lastDate = date.lastDate else {
                    log(.error, "Failed to get a date. \(year). \(month)")
                    return
                }
                
                title = dateFormatter.string(from: startDate)
                
                switch lines {
                case 1:
                    let weekDay = firstDate.weekDay
                    if 1 < weekDay, let date = firstDate.date(days:  -(13 + weekDay)) {
                        firstDate = date
                    }
                    
                    var week = [Day]()
                    for weekIndex in 0..<6 {
                        guard let firstDate = firstDate.date(weeks: weekIndex) else {
                            log(.error, "Failed to get the first date.")
                            return
                        }
                            
                        week.removeAll()
                        
                        for days in 0..<42 {
                            guard let date = firstDate.date(days: days) else {
                                log(.error, "Failed to get a day.")
                                return
                            }
                        
                            week.append(Day(date: date, validDate: lastDate))
                        }
                    
                        weeks.append(week)
                    }
                    
                    
                default:
                    // First date
                    let weekDay = firstDate.weekDay
                    if 1 < weekDay, let previousMonth = firstDate.date(days: 1 - weekDay) {
                        firstDate = previousMonth
                    }
                    
                    
                    // Last date
                    guard let totalDays = lastDate.days(from: firstDate) else {
                        log(.error, "Failed to get a totalDays.")
                        return
                    }
                    
                    if totalDays < 41, let date = lastDate.date(days: 41 - totalDays) {
                        lastDate = date
                    }
                    
                    var week = [Day(date: firstDate, validDate: date)]
                    while firstDate < lastDate {
                        guard let next = firstDate.date(days: 1) else {
                            log(.error, "Failed to get a date. firstDate: \(firstDate), lastDate:\(lastDate)")
                            break
                        }
                        
                        firstDate = next
                        week.append(Day(date: next, validDate: date))
                    }
                    
                    weeks.append(week)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.weeks = weeks
            self.title = title
        }
    }
    
    func handle(data: Day) {
        for (section, month) in weeks.enumerated() {
            for (row, day) in month.enumerated() {
                guard day == data else { continue }
                weeks[section][row].isSelected.toggle()
                return
            }
        }
    }
    
    func updateCalendar(offset: CGPoint, isEnded: Bool) {
        let height = max(compactHeight, min(expandedHeight, expandedHeight - offset.y))
        let lines = UInt(min(6, ceil(height / compactHeight)))
        
        let ratio = (height - compactHeight) / (expandedHeight - compactHeight)
        calenderOffsetY = compactHeight / 2 * (1 - ratio)
        
        switch isEnded {
        case false:
            guard calendarHeight != height else { return }
            calendarHeight = height
            
            guard self.lines != lines else { return }
            self.lines = lines
            
        case true:
            self.lines = lines
//            self.offset.y = lines == 1 ? 60 : expandedHeight
            
//            request()
        }
        
    }

    // MARK: Private
    private func updateSection() {
        guard page < weeks.count, let date = weeks[page].first?.validDate else { return }
        withAnimation {
            title = dateFormatter.string(from: date)
        }
    }
}
