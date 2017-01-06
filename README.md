# LazyTransitions

A simple framework that allows you to create similar lazy transitions like in the Facebook, Instagram or Twitter apps.

## Installation

### CocoaPods

Add the following line to your PodFile:

``` pod 'LazyTransitions' , :git => 'https://github.com/serp1412/LazyTransitions.git' ``` 

## Usage

Here's the simplest way to use LazyTransitions in your project.
Let's assume you want to add a lazy dismiss in all four directions to a simple view controller. 

```swift
// first of all import LazyTransitions
import LazyTransitions

class MyVC : UIViewController {
    fileprivate let transitioner = UniversalTransitionsHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the main view to your transition handler
        transitioner.addTransition(for: view)
        
        // become your delegate for custom view controller transitioning
        transitioningDelegate = self
        
        // become the transitioner delegate
        transitioner.delegate = self
    }
}

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

// in the transitioner delegate begin your transition (call dismiss)
extension MyVC : TransitionerDelegate {
    func beginTransition(with transitioner: Transitioner) {
        dismiss(animated: true, completion: nil)
    }
}
```
