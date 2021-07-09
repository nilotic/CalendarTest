//
//  DayCell.swift
//  Calendar
//
//  Created by Den Jo on 2021/07/08.
//

import SwiftUI

struct DayCell: View {
    
    // MARK: - Value
    // MARK: Public
    let data: Day
    var completion: (() -> Void)? = nil
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        VStack {
            Text("\(data.date.day)")
                .foregroundColor(data.color)
                .background(data.isSelected ? overlay : nil)
                .opacity(data.opacity)
                .padding(.top, 12)
        
            if data.isSelected {
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundColor(Color.gray)
            }
        }
        .frame(height: 60, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .onTapGesture {
            completion?()
        }
        
    }
    
    private var overlay: some View {
        Circle()
            .frame(width: 27, height: 27)
            .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
    }
}

#if DEBUG
struct CalendarCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = DayCell(data: .placeholder)
        
        Group {
            view
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 12")
        }
    }
}
#endif
