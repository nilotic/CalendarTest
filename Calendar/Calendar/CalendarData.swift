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
    
    @Published var calendarHeight: CGFloat = 60 * 6 + 1 * 5
    @Published var scrollOffset: CGFloat   = 0
    @Published var ratio: CGFloat          = 0
    @Published var constants               = [CGFloat]()
    @Published var calendarViewID          = 0
    
    @Published var page: UInt = 0 {
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
    private var lines: UInt = 1
    private var selectedDays = [Int: [(Day, Int)]]()
    private var selectedFirstWeek: UInt = 0
    
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
        var weeks     = [[Day]]()
        var constants = [CGFloat]()
        var title     = ""
        let lines     = lines
        
        for year in startDate.year...endDate.year {
            for month in startDate.month...endDate.month {
                guard let date = Calendar.current.date(from: DateComponents(timeZone: TimeZone(abbreviation: "UTC"), year: year, month: month, day: 1)), var firstDate = date.firstDate, var lastDate = date.lastDate else {
                    log(.error, "Failed to get a date. \(year). \(month)")
                    return
                }
                
                title = dateFormatter.string(from: startDate)
                
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
                
                
                // Month
                var validLastIndex = 0
                var week = [Day(date: firstDate, validDate: date)]
                
                while firstDate < lastDate {
                    guard let next = firstDate.date(days: 1) else {
                        log(.error, "Failed to get a date. firstDate: \(firstDate), lastDate:\(lastDate)")
                        break
                    }
                    
                    firstDate = next
                    
                    let day = Day(date: next, validDate: date)
                    week.append(day)
                    
                    guard day.isValid else { continue }
                    validLastIndex = max(0, week.count - 1)
                }
                
                weeks.append(week)
                constants.append(0)
                
                // Duplicate the month
                guard lines == 1 else { continue }
                for i in 1...Int(validLastIndex / 7) {
                    weeks.append(week)
                    constants.append(-(compactHeight + 1) * CGFloat(i))
                }
            }
        }
        
        DispatchQueue.main.async {
            self.weeks     = weeks
            self.constants = constants
            self.title     = title
        }
    }
    
    func handle(data: Day) {
        var targetPage: UInt? = nil
        
        for (section, month) in weeks.enumerated() {
            for (row, day) in month.enumerated() {
                guard day == data else { continue }
                weeks[section][row].isSelected.toggle()
                
                // Update the selected first week
                let day = weeks[section][row]
                var days = selectedDays[section] ?? []
                
                switch day.isSelected {
                case true:  days.append((day, row))
                case false: days.removeAll(where: { $0.0 == day })
                }
                
                days.sort { $0.1 < $1.1 }
                
                selectedFirstWeek = UInt((days.first?.1 ?? 0) / 7)
                selectedDays[section] = days
                
                // Target page
                guard targetPage == nil else { continue }
                targetPage = selectedFirstWeek + UInt(section)
            }
        }
        
        // For updating the calendarView, update the id
        withAnimation {
            calendarViewID += 1
        }
        
        // Move to the target page
        guard let page = targetPage, self.page != page else { return }
        self.page = page
    }
    
    func updateCalendar(offset: CGPoint, isEnded: Bool) {
        let height = max(compactHeight, min(expandedHeight, expandedHeight - offset.y))
        let lines = UInt(min(6, ceil(height / compactHeight)))
        
        switch isEnded {
        case false:
            // Offset
            ratio = 1 - ((height - compactHeight) / (expandedHeight - compactHeight))
            
            guard calendarHeight != height else { return }
            calendarHeight = height
            
            guard self.lines != lines else { return }
            self.lines = lines
            
        case true:
            
            guard !(self.lines == 1 || self.lines == 6) else { return }
            log(.info, "\(lines) \(offset)")
            self.lines = lines
            
//            ratio = lines == 1 ? 1 : 0
            scrollOffset = lines == 1 ? (expandedHeight - compactHeight) : 0
        }
        
    }

    // MARK: Private
    private func updateSection() {
        guard page < weeks.count, let date = weeks[Int(page)].first?.validDate else { return }
        
        let days = selectedDays[Int(page)] ?? []
        selectedFirstWeek = UInt((days.first?.1 ?? 0) / 7)
        
        withAnimation {
            title = dateFormatter.string(from: date)
        }
    }
}
