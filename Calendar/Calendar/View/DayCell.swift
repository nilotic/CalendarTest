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
    private let data: Day
    private let completion: (() -> Void)?
    
    // MARK: Private
    @State var isSelected = false
    
    
    // MARK: - Initializer
    init(data: Day, completion: (() -> Void)? = nil) {
        self.data = data
        self.completion = completion
        
        isSelected = data.isSelected
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        VStack {
            if data.isValid {
                Text("\(data.date.day)")
                    .foregroundColor(data.color)
                    .background(isSelected ? overlay : nil)
                    .opacity(data.opacity)
                    .padding(.top, 12)
            
                if data.isSelected {
                    Circle()
                        .frame(width: 7, height: 7)
                        .foregroundColor(Color.gray)
                }
            }
        }
        .frame(height: 60, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .disabled(!data.isValid)
        .onTapGesture {
            completion?()
        }
    }
    
    // MARK: Private
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
