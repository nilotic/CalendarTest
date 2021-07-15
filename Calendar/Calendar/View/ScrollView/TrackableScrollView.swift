import SwiftUI

struct TrackableScrollView<Content: View>: UIViewControllerRepresentable {
    
    // MARK: - Value
    // MARK: Private
    private let inset: UIEdgeInsets
    private let range: ClosedRange<CGFloat>
    private let content: () -> Content
    private var completion: ((_ offset: CGPoint, _ isEnded: Bool) -> Void)? = nil
    
    
    // MARK: - Initializer
    init(inset: UIEdgeInsets, range: ClosedRange<CGFloat>, @ViewBuilder content: @escaping () -> Content, completion: ((_ offset: CGPoint, _ isEnded: Bool) -> Void)?) {
        self.inset      = inset
        self.range      = range
        self.content    = content
        self.completion = completion
    }
    
    
    // MARK: - Function
    // MARK: Public
    func makeUIViewController(context: Context) -> UIScrollViewViewController {
        UIScrollViewViewController(view: AnyView(content()), inset: inset, range: range, completion: completion)
    }
    
    func updateUIViewController(_ viewController: UIScrollViewViewController, context: Context) {
        viewController.hostingController.rootView = AnyView(content())
    }
}
