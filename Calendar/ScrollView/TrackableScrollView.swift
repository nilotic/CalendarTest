import SwiftUI

struct TrackableScrollView<Content: View>: UIViewControllerRepresentable {
    
    // MARK: - Value
    // MARK: Private
    private let inset: UIEdgeInsets
    private let content: () -> Content
    private var completion: ((_ offset: CGPoint, _ isEnded: Bool) -> Void)? = nil
    
    @Binding private var offset: CGPoint
    @State private var cache: CGPoint = .zero
    
    // MARK: - Initializer
    init(inset: UIEdgeInsets, offset: Binding<CGPoint>,  @ViewBuilder content: @escaping () -> Content, completion: ((_ offset: CGPoint, _ isEnded: Bool) -> Void)?) {
        self.inset      = inset
        self.content    = content
        self.completion = completion
        
        _offset = offset
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
        
        guard cache != offset else { return }
        DispatchQueue.main.async {
            cache = offset
            viewController.scrollView.setContentOffset(offset, animated: true)
        }
    }
}
