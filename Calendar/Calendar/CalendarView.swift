//
//  CalendarView.swift
//  Calendar
//
//  Created by Den Jo on 2021/07/08.
//

import SwiftUI

struct CalendarView: View {
    
    // MARK: - Value
    // MARK: Private
    @ObservedObject private var data = CalendarData()
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        VStack(spacing: 0) {
            headerView
            weekDaysView
            daysView
            
            Spacer()
        }
        .onAppear {
            data.request()
        }
    }
    
    
    // MARK: Private
    private var headerView: some View {
        Text(data.section)
            .font(.system(size: 30, weight: .semibold, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 30, trailing: 15))
            .transition(data.transition)
            .id(data.section)
    }
    
    private var weekDaysView: some View {
        HStack {
            Group {
                Text("일")
                    .foregroundColor(.red)
                
                Group {
                    Text("월")
                    Text("화")
                    Text("수")
                    Text("목")
                    Text("금")
                }
                
                Text("토")
                    .foregroundColor(.blue)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
    }
    
    private var daysView: some View {
        TabView(selection: $data.page) {
            ForEach(Array(data.months.enumerated()), id: \.element) { (i, month) in
                VStack(spacing: 1) {
                    ForEach(month, id: \.self) { days in
                        HStack(spacing: 1) {
                            ForEach(days) { day in
                                DayCell(data: day) {
                                    data.update(data: day)
                                }
                            }
                        }
                    }
                }
                .tag(i)
            }
            .background(Color.white)
        }
        .frame(height: 60 * 6 + 1 * 5)
        .tabViewStyle(PageTabViewStyle())
    }
}

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = CalendarView()
        
        Group {
            view
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 12")
        }
    }
}
#endif
