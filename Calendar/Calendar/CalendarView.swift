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
    @StateObject private var data = CalendarData()
   
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack(alignment: .top) {
            Group {
                transactionHistoryView

                VStack(spacing: 0) {
                    headerView
                    weekDaysView
                    daysView
                }
            }
           
            if data.isProgressing {
                ZStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5, anchor: .center)
                        .padding(.bottom, 120)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            data.request()
        }
    }
    
    
    // MARK: Private
    private var headerView: some View {
        Text(data.title)
            .font(.system(size: 30, weight: .semibold, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 30, trailing: 15))
            .transition(data.transition)
            .id(data.title)
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
        CalendarPageView(data: data.weeks, page: $data.page, constants: data.constants, ratio: data.ratio) { day in
            data.handle(data: day)
        }
        .frame(height: data.calendarHeight)
        .border(Color.white, width: 1)
        .id(data.calendarViewID)
        
        
        /*
        TabView(selection: $data.page) {
            ForEach(data.weeks, id: \.self) { month in
                LazyVGrid(columns: data.columns, spacing: 1) {
                    ForEach(month) { day in
                        DayCell(data: day) { updated in
                            data.handle(data: updated)
                        }
                    }
                }
                .id(UUID())
            }
            .background(Color.white)
            .offset(y: data.calendarOffset)
            .border(Color.white, width: 1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: data.calendarHeight)
 */
         
    }
    
    private var transactionHistoryView: some View {
        GeometryReader { proxy in
            VStack {
                TrackableScrollView(inset: UIEdgeInsets(top: data.range.upperBound - 70, left: 0, bottom: 0, right: 0), range: data.range) {
                    LazyVStack {
                        Text("신한 110123130243")
                            .font(.system(size: 13))
                            .frame(height: 30)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(0...10, id: \.self) { i in
                            withdrawCell
                            depositCell
                            dateHeader
                        }
                    }
                    .padding(20)
                    .frame(width: proxy.size.width)
                    
                } completion: { offset, isEnded in
                    data.updateCalendar(offset: offset, isEnded: isEnded)
                }
            }
            .padding(.top, proxy.safeAreaInsets.top + 135)
        }
    }
    
    private var dateHeader: some View {
        Text("2021년 7월 13일(화)")
            .font(.system(size: 15))
            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            .frame(height: 50)
    }
    
    private var depositCell: some View {
        HStack {
            VStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color(#colorLiteral(red: 0.8784229159, green: 0.8819318414, blue: 0.9079707265, alpha: 1)))
                        .frame(height: 55)
                    
                    HStack {
                        Text("45,000원")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Text(">")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(#colorLiteral(red: 0.6508923769, green: 0.6545740962, blue: 0.6762641668, alpha: 1)))
                    }
                    .padding(.horizontal, 15)
                }
                
                Text("오후 1:14")
                    .font(.system(size: 13))
                    .foregroundColor(Color(#colorLiteral(red: 0.5950363278, green: 0.6112565398, blue: 0.6588510871, alpha: 1)))
            }
                
            Spacer()
                .frame(maxWidth: .infinity)
        }
    }
    
    private var withdrawCell: some View {
        HStack {
            Spacer()
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .trailing) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1)))
                        .frame(height: 55)
                    
                    HStack {
                        Text("-20,000원")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Text(">")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(#colorLiteral(red: 0.7489310503, green: 0.6307500005, blue: 0.9994017482, alpha: 1)))
                    }
                    .padding(.horizontal, 15)
                }
                
                Text("오후 1:14")
                    .font(.system(size: 13))
                    .foregroundColor(Color(#colorLiteral(red: 0.5950363278, green: 0.6112565398, blue: 0.6588510871, alpha: 1)))
            }
        }
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
