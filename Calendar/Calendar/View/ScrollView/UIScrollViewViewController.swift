import SwiftUI

final class UIScrollViewViewController: UIViewController {
    
    // MARK: - Value
    // MARK: Public
    var hostingController: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))
    var inset: UIEdgeInsets = .zero
    var range: ClosedRange<CGFloat> = 0...0
    var completion: ((_ offset: CGPoint, _ isEnded: Bool) -> Void)? = nil
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset                 = inset
        scrollView.delegate                     = self
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive   = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive           = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive     = true
    
        return scrollView
    }()
    
    
    // MARK: - Initializer
    convenience init(view: AnyView, inset: UIEdgeInsets, range: ClosedRange<CGFloat>, completion: ((_ offset: CGPoint, _ isEnded: Bool) -> Void)?) {
        self.init()
        
        hostingController = UIHostingController(rootView: view)
        
        self.inset      = inset
        self.range      = range
        self.completion = completion
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.addSubview(hostingController.view)
        hostingController.willMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive   = true
        hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive           = true
        hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive     = true
        hostingController.didMove(toParent: self)
        
        let constraint = hostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor)
        constraint.priority = .defaultLow
        constraint.isActive = true
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func updateMagneticEffect() {
        let height     = max(range.lowerBound, min(range.upperBound, range.upperBound - (scrollView.contentOffset.y + scrollView.contentInset.top)))
        let lane       = UInt(min(6, ceil(height / range.lowerBound)))
        let targetLane = lane  <= 3 ? 1 : 6
        let y          = targetLane == 6 ? -scrollView.contentInset.top : (range.upperBound - range.lowerBound) - scrollView.contentInset.top
        
        guard !(lane == 1 || lane == 6) else { return }
        scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
    }
}


// MARK: - UIScrollView Delegate
extension UIScrollViewViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        completion?(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + scrollView.contentInset.top), false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        completion?(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + scrollView.contentInset.top), true)
        updateMagneticEffect()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        completion?(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + scrollView.contentInset.top), true)
        updateMagneticEffect()
    }
}
