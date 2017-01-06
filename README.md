# LazyTransitions

A simple framework that allows you to create similar lazy transitions like in the Facebook, Instagram or Twitter apps.

## Installation

### CocoaPods

Add the following line to your PodFile:

``` pod 'LazyTransitions' , :git => 'https://github.com/serp1412/LazyTransitions.git' ``` 

## Usage

Here's the simplest way to use LazyTransitions in your project.

```swift
// first of all import LazyTransitions
import LazyTransitions

class MyVC : UIViewController {
    fileprivate let transitioner = UniversalTransitionsHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the main view to your transition handler
        transitioner.addTransition(for: view)
        
        // FOR DISMISS
        // become your delegate for custom view controller transitioning
        transitioningDelegate = self
        
        // or FOR POP
        // become the delegate for your navigation controller
        navigationController.delegate = self
        
        // become the transitioner delegate
        transitioner.delegate = self
    }
}

// FOR DISMISS
// in the view controller's transitioning methods...
extension MyVC : UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // ... pass the animator
        return transitioner.animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // ... pass the interactor
        return transitioner.interactor
    }
}

// FOR POP
// in the navigation controller's delegate methods
extension MyVC : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .pop else { return nil }
        // ... pass the animator if the operation is pop
        return transitioner.animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // ... pass the interactor
        return transitioner.interactor
    }
}

// in the transitioner delegate begin your transition
extension MyVC : TransitionerDelegate {
    func beginTransition(with transitioner: Transitioner) {
        // FOR DISMISS call dismiss
        dismiss(animated: true, completion: nil)
        // FOR POP call pop
        _ = navigationController?.popViewController(animated: true)
    }
}
```

If you have a UIScrollView in that view controller and you want to begin a transition when user scrolls to its edges, you can just use: 

```swift
transitioner.addTransition(for: scrollView)
```

To add the a bouncy effect when user scrolls with inertia and the UIScrollView reaches its edges, do the following:
```swift
// become the delegate of your UIScrollView
scrollView.delegate = self

// implement the scrollViewDidScroll() delegate method
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // forward it to the transitioner
    transitioner.didScroll(scrollView)
}
```
