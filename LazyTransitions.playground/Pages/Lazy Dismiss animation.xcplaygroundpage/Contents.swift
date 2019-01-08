/*:
 # How to add a lazy Dismiss Animation
 */


import LazyTransitions
import PlaygroundSupport

/*
 **NOTE**: By default panning on your main view will trigger a transition.
 Use `addTransition(forView:)` and `addTransition(forScrollView:)` functions to add triggers on other views.
 */
class LazyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 1. Call the `becomeLazy(for: TransitionType)` function and pass in whether this screen is going to be lazily dismissed or popped (i.e. if it was presented or is inside a navigation stack)
         */
        becomeLazy(for: .dismiss)
    }
}

/* Run this playground to see it in action.

 Try swiping the blue screen in any direction */

//: [NEXT: Lazy Pop Animation](Lazy%20Pop%20animation)











































/* Oh hey there, didn't expect you to scroll down here. You won't find anything special here, just some setup code ☺️ */

extension LazyViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = .blue
    }
}

let backVC = BackgroundViewController.instantiate(with: LazyViewController.self, action: { presented, presenting in
    presenting.present(presented, animated: true, completion: nil)
})
backVC.view.frame = .iphone6

PlaygroundPage.current.liveView = backVC.view
