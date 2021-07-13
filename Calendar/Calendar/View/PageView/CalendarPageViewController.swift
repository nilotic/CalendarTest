import SwiftUI
import UIKit

struct CalendarPageViewController<Page: View> {
    
    // MARK: - Value
    // MARK: Pubilc
    let pages: [Page]
    let offset: CGFloat
    @Binding var page: Int

    // MARK: Private
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
}


// MARK: - UIViewController Representable
extension CalendarPageViewController: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewController: self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate   = context.coordinator
        
        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        guard page < context.coordinator.viewControllers.count else { return }
        pageViewController.setViewControllers([context.coordinator.viewControllers[page]], direction: .forward, animated: true)
        
        for constraint in context.coordinator.constraints {
            constraint.constant = offset
        }
    }
}


// MARK: - UIPageViewController
extension CalendarPageViewController {
    
    final class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
        
        // MARK: - Value
        // MARK: Public
        let viewControllers: [UIViewController]
        let constraints: [NSLayoutConstraint]
        
        // MARK: Private
        private var viewController: CalendarPageViewController
        private var currentIndex = 0
        
        
        // MARK: - Initializer
        init(viewController: CalendarPageViewController) {
            var constraints     = [NSLayoutConstraint]()
            var viewControllers = [UIViewController]()
            
            for page in viewController.pages {
                let hostingController = UIHostingController(rootView: page)
                hostingController.view.backgroundColor = .clear
                
                let viewController = UIViewController()
                viewController.view.addSubview(hostingController.view)
                
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                hostingController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive     = true
                hostingController.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive   = true
                hostingController.view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
                
                let topConstraint = hostingController.view.topAnchor.constraint(equalTo: viewController.view.topAnchor)
                topConstraint.isActive = true
                constraints.append(topConstraint)
                
                hostingController.willMove(toParent: viewController)
                
                viewControllers.append(viewController)
                constraints.append(topConstraint)
            }
            
            self.viewController  = viewController
            self.viewControllers = viewControllers
            self.constraints     = constraints
            
            super.init()
        }
        
        
        // MARK: - PageViewController
        // MARK: DataSource
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = viewControllers.firstIndex(of: viewController), 1 < viewControllers.count else { return nil }
            return index == 0 ? nil : viewControllers[index - 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = viewControllers.firstIndex(of: viewController), 1 < viewControllers.count else { return nil }
            return index + 1 == viewControllers.count ? nil : viewControllers[index + 1]
        }

        // MARK: Delegate
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            guard completed, let visibleViewController = pageViewController.viewControllers?.first, let index = viewControllers.firstIndex(of: visibleViewController) else { return }
            viewController.page = index
        }
    }
}
