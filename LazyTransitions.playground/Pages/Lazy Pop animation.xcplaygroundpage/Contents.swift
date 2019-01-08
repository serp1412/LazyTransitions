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

        view.backgroundColor = .blue
        /*
         1. Call the `becomeLazy(for: TransitionType)` function and pass in whether this screen is going to be lazily dismissed or popped (i.e. if it was presented or is inside a navigation stack)
         */
        becomeLazy(for: .pop)
    }
}

/* Run the Playground to see how it works

 Try swiping left to right to pop the blue screen

 **NOTE**: By default becoming lazy for .pop allows to pop the screen only left to right. If you want to add right to left as well you can add `allowedOrientations = [.leftToRight, .rightToLeft]` in `viewDidLoad`
 */

//: [NEXT: Limit Transition Orientations](Limit%20transition%20orientations)       [PREVIOUS: Lazy Dismiss Animation](Lazy%20Dismiss%20animation)





























/* Oh hey there, didn't expect you to scroll down here. You won't find anything special here, just some setup code ☺️ */

extension LazyViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = .blue
    }
}

let nav = UINavigationController()
nav.view.frame = .iphone6

let backVC = BackgroundViewController.instantiate(with: LazyViewController.self, action: { presented, presenting in

    presenting.navigationController?.pushViewController(presented, animated: true)
})


nav.pushViewController(backVC, animated: false)
PlaygroundPage.current.liveView = nav.view

backVC.navigationController?.delegate = backVC

/*
 Fix bug with child scroll views triggering transition
 Write README in playgrounds
 Delete Example project
 Delete Xcode10Playground
 Update README in repository
 */
