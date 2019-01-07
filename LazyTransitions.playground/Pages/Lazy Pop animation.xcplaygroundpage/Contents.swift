/*:
 # How to add a lazy Pop Animation
 */

import LazyTransitions
import PlaygroundSupport

/*
  **NOTE**: By default panning on your main view will trigger a transition.

 Call the `addTransition(forScrollView:)` or `addTransition(forView)` functions if you want make other views trigger a transition
 */

class LazyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         1. Call the `becomeLazy(for: TransitionType)` function and pass in whether this screen is going to be lazily dismissed or popped (i.e. if it was presented or is inside a navigation stack)
         */
        becomeLazy(for: .pop)
    }
}

/* Run the Playground to see how it works

 Try swiping left to right to pop the blue screen
 */
























let nav = UINavigationController()
nav.view.frame = .iphone6


let lazyVC = LazyViewController()
let backVC = BackgroundViewController.instantiate(with: lazyVC, action: { presented, presenting in

    presenting.navigationController?.pushViewController(presented, animated: true)
})

lazyVC.view.backgroundColor = .blue

nav.pushViewController(backVC, animated: false)
PlaygroundPage.current.liveView = nav.view


/*
 Check that navigation delegate methods are forwarded
 Fix memory leaks
 Fix bug with child scroll views triggering transition
 Write README in playgrounds
 Delete Example project
 Delete Xcode10Playground
 Update README in repository
 */
