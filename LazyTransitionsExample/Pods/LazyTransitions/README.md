<h1 align="center">LazyTransitions</h1>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS8+-blue.svg?style=flat" alt="Platform: iOS 8+"/>
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift%203-4BC51D.svg?style=flat" alt="Language: Swift 3" /></a>
    <img src="http://img.shields.io/badge/license-BSD-lightgrey.svg?style=flat" alt="License: BSD" />
    <a href="http://twitter.com/serp1412"><img src="https://img.shields.io/badge/twitter-@serp1412-blue.svg?style=flat" alt="Twitter: serp1412" /></a>
</p>

A simple framework that allows you to create similar lazy pops and dismisses like in the Facebook, Instagram or Twitter apps.

<p align="center" >
<img src="https://github.com/serp1412/LazyTransitions/blob/master/LazyTransitionsDemo.gif" alt="LazyTransitions" title="LazyTransitions demo">
</p>

## Installation

### CocoaPods

Add the following line to your PodFile:

``` pod 'LazyTransitions' , :git => 'https://github.com/serp1412/LazyTransitions.git' ``` 

## Usage

The simplest way to use this framework is to take advantage of `LazyTransitioner` class.

* Import the framework
```swift
import LazyTransitions
```
* Create an instance of `LazyTransitioner`
```swift
let transitioner = LazyTransitioner()
```
* Pass your transition views (views that will trigger a transition when user pans on them) to the transitioner
```swift
transitioner.addTransition(forView: view)
// or
transitioner.addTransition(forScrollView: scrollView)
```
* In the `triggerTransitionAction` trigger your transition (dismiss or pop)
```swift
transitioner.triggerTransitionAction = { [weak self] _ in
    self?.dismiss(animated: true, completion: nil)
}
```

* Set your transitioner as the transitioning delegate.

For Dismiss:
```swift
transitioningDelegate = transitioner
```

For Pop:
```swift
navigationController?.delegate = transitioner
```

### Example

Here's some sample code on how to use LazyTransitions in your project.

```swift
// first of all import LazyTransitions
import LazyTransitions

class MyVC : UIViewController {
    fileprivate let transitioner = LazyTransitioner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the main view to your transitioner
        transitioner.addTransition(forView: view)
        
        // trigger the transition in triggerTransitionAction
        transitioner.triggerTransitionAction = { [weak self] _ in
            // for dismiss
            self?.dismiss(animated: true, completion: nil)
            // or for pop
            _ = self?.navigationController?.popViewController(animated: true)
        }
        
        // FOR DISMISS
        // set transitioner as the delegate for custom view controller transitioning
        transitioningDelegate = transitioner
        
        // or FOR POP
        // set transitioner as the delegate for your navigation controller
        navigationController.delegate = transitioner
    }
}
```

## Usage Tips

* To add the a bouncy effect when user scrolls with inertia and the UIScrollView reaches its edges, do the following:
```swift
// become the delegate of your UIScrollView
scrollView.delegate = self

// implement the scrollViewDidScroll() delegate method
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // forward it to the transitioner
    transitioner.didScroll(scrollView)
}
```

* To achieve the standard pop animation of iOS, use the provided `PopAnimator` when initializing the `LazyTransitioner`

```swift 
let transitioner = LazyTransitioner(animator: PopAnimator(orientation: .leftToRight))
```

* You can limit the allowed transition orientations by setting them like this:
```swift
transitioner.allowedOrientations = [.leftToRight, .topToBottom, .bottomToTop]
```

* In case you need to assign something else as the transitioning delegate, then you can simply forward the `animator` and `interactor` properties of your transitioner inside the delegate methods.

Like so in case of dismiss:
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
