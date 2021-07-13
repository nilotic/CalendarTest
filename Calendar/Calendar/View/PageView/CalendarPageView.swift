import SwiftUI
import Combine

struct CalendarPageView: View {
    
    // MARK: - Value
    // MARK: Private
    @Binding private var page: Int
    private let data: [[Day]]
    private let offset: CGFloat
    
    private let completion: ((_ day: Day) -> Void)
    
    
    // MARK: - Initialier
    init(data: [[Day]], page: Binding<Int>, offset: CGFloat, completion: @escaping ((_ day: Day) -> Void)) {
        self.data       = data
        self.offset     = offset
        self.completion = completion
        
        _page = page
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        if !data.isEmpty {
            CalendarPageViewController(pages: data.map { weeks in
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 7), spacing: 1) {
                    ForEach(weeks) { day in
                        DayCell(data: day) { updatedDay in
                            completion(updatedDay)
                        }
                    }
                }
                .drawingGroup()
                .background(Color.white)
                .border(Color.white, width: 1)
                
            }, offset: offset, page: $page)
        }
    }
}
