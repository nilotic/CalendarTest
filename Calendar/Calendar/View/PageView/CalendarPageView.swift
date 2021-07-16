import SwiftUI
import Combine

struct CalendarPageView: View {
    
    // MARK: - Value
    // MARK: Private
    @Binding private var page: UInt
    @Binding private var lane: UInt
    
    private let data: [[Day]]
    private let ratio: CGFloat
    private let monthIndices: [UInt]
    private let selectedDays: [Int: [(Day, Int)]]
    private let constants: [CGFloat]
    private let completion: ((_ day: Day) -> Void)
    
    
    // MARK: - Initialier
    init(data: [[Day]], page: Binding<UInt>, lane: Binding<UInt>, monthIndices: [UInt], selectedDays: [Int: [(Day, Int)]], constants: [CGFloat], ratio: CGFloat, completion: @escaping ((_ day: Day) -> Void)) {
        self.data         = data
        self.monthIndices = monthIndices
        self.selectedDays = selectedDays
        self.constants    = constants
        self.ratio        = ratio
        self.completion   = completion
        
        _page = page
        _lane = lane
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
                
            }, page: $page, lane: $lane, monthIndices: monthIndices, selectedDays: selectedDays, constants: constants, ratio: ratio)
        }
    }
}
