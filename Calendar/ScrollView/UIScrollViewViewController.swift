import SwiftUI

final class UIScrollViewViewController: UIViewController {
    
    // MARK: - Value
    // MARK: Public
    var hostingController: UIHostingController<AnyView> = UIHostingController(rootView: AnyView(EmptyView()))
    var inset: UIEdgeInsets = .zero
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
}


// MARK: - UIScrollView Delegate
extension UIScrollViewViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        completion?(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + scrollView.contentInset.top), false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        completion?(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + scrollView.contentInset.top), true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        completion?(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + scrollView.contentInset.top), true)
    }
}
