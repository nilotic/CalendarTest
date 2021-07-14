import SwiftUI
import Combine

struct CalendarPageView: View {
    
    // MARK: - Value
    // MARK: Private
    @Binding private var page: UInt
    
    private let data: [[Day]]
    private let ratio: CGFloat
    private let constants: [CGFloat]
    private let completion: ((_ day: Day) -> Void)
    
    
    // MARK: - Initialier
    init(data: [[Day]], page: Binding<UInt>, constants: [CGFloat], ratio: CGFloat, completion: @escaping ((_ day: Day) -> Void)) {
        self.data       = data
        self.constants  = constants
        self.ratio      = ratio
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
                        DayCell(data: day) {
                            completion(day)
                        }
                    }
                }
                .drawingGroup()
                .background(Color.white)
                .border(Color.white, width: 1)
                
            }, constants: constants, ratio: ratio, page: $page)
        }
    }
}
