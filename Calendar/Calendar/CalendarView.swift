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
        VStack(spacing: 25) {
            weekDaysView
            daysView
        }
        .onAppear {
            data.request()
        }
    }
    
    
    // MARK: Private
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
            .frame(maxWidth: .infinity)
        }
    }
    
    private var daysView: some View {
        ScrollView {
            LazyVGrid(columns: data.columns, spacing: 1) {
                ForEach(data.days) { day in
                    DayCell(data: day) {
                        data.update(data: day)
                    }
                }
            }
        }
        .background(Color.white)
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
