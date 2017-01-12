# LazyTransitions

[![Twitter](https://img.shields.io/badge/twitter-@serp1412-blue.svg?style=flat)](http://twitter.com/serp1412)

A simple framework that allows you to create similar lazy pops and dismisses like in the Facebook, Instagram or Twitter apps.

<p align="center" >
<img src="https://github.com/serp1412/LazyTransitions/blob/master/LazyTransitionsDemo.gif" alt="LazyTransitions" title="LazyTransitions demo">
</p>

## Installation

### CocoaPods

Add the following line to your PodFile:

``` pod 'LazyTransitions' , :git => 'https://github.com/serp1412/LazyTransitions.git' ``` 

## Usage

The simplest way to use this framework is to take advantage of `UniversalTransitionsHandler` class.

You can just give it the views in your view controller that will trigger a transition when the user swipes on them. 
It could be a simple static view. Or a scroll view that will trigger the transition when it reaches the edges of it's content.

* Import the framework
```swift
import LazyTransitions
```
* Create an instance of `UniversalTransitionsHandler`
```swift
let transitioner = UniversalTransitionsHandler()
```
* Pass your transition views (views that will trigger a transition when user pans on them) to the handler
```swift
transitioner.addTransition(for: view)
// or
transitioner.addTransition(for: scrollView)
```
* In the `beginTransitionAction` trigger your transition (dismiss or pop)
```swift
transitioner.beginTransitionAction = { [weak self] _ in
    self?.dismiss(animated: true, completion: nil)
}
```

* In your transitioning delegate methods pass the animator and interactor from the transition handler
```swift
func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    // ... pass the animator
    return transitioner.animator
}
    
func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    // ... pass the interactor
    return transitioner.interactor
}
```

### Example

Here's some sample code on how to use LazyTransitions in your project.

```swift
// first of all import LazyTransitions
import LazyTransitions

class MyVC : UIViewController {
    fileprivate let transitioner = UniversalTransitionsHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the main view to your transition handler
        transitioner.addTransition(for: view)
        
        // trigger the transition in beginTransitionAction
        transitioner.beginTransitionAction = { [weak self] _ in
            // for dismiss
            self?.dismiss(animated: true, completion: nil)
            // or for pop
            _ = self?.navigationController?.popViewController(animated: true)
        }
        
        // FOR DISMISS
        // become your delegate for custom view controller transitioning
        transitioningDelegate = self
        
        // or FOR POP
        // become the delegate for your navigation controller
        navigationController.delegate = self
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
    
    func navigationController(_ navigationController: UINavigationController, 
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // ... pass the interactor
        return transitioner.interactor
    }
}
```

## Usage Tips

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

To achieve the standard pop animation of iOS, use the provided `PopAnimator` when initializing the `UniversalTransitionsHandler`

```swift 
let transitioner = UniversalTransitionsHandler(animator: PopAnimator(orientation: .leftToRight))
```

You can limit the allowed transition orientations by setting them like this:
```swift
transitioner.allowedOrientations = [.leftToRight, .topToBottom, .bottomToTop]
```
