import SwiftUI

struct TrackableScrollView<Content: View>: UIViewControllerRepresentable {
    
    // MARK: - Value
    // MARK: Private
    private let inset: UIEdgeInsets
    private let content: () -> Content
    private var completion: ((_ offset: CGPoint, _ isEnded: Bool) -> Void)? = nil
    
    private let offset: CGFloat
    @State private var cache: CGFloat = 0
    
    // MARK: - Initializer
    init(inset: UIEdgeInsets, offset: CGFloat, @ViewBuilder content: @escaping () -> Content, completion: ((_ offset: CGPoint, _ isEnded: Bool) -> Void)?) {
        self.inset      = inset
        self.offset     = offset
        self.content    = content
        self.completion = completion
    }
    
    
    // MARK: - Function
    // MARK: Public
    func makeUIViewController(context: Context) -> UIScrollViewViewController {
        let viewController = UIScrollViewViewController()
        viewController.inset      = inset
        viewController.completion = completion
        viewController.hostingController.rootView = AnyView(content())
        return viewController
    }
    
    func updateUIViewController(_ viewController: UIScrollViewViewController, context: Context) {
        viewController.hostingController.rootView = AnyView(content())
        
        log(.info, "\(cache) \(offset)")
        guard cache != offset else { return }
        cache = offset
        viewController.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    }
}
