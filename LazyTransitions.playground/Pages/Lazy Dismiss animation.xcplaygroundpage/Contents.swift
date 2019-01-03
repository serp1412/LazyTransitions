/*:
 # How to add a lazy Dismiss Animation
 */


import LazyTransitions
import PlaygroundSupport

/*
 1. Conform the controller you want to become lazy to `LazyScreen`.

 **NOTE**: By default panning on your main view will trigger a transition.
 Override `views` and `scrollViews` properties if you want pans on other views to trigger a transition
 */
class LazyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 3. Initialize the transitioner by passing `self` as the lazy screen and providing `.dismiss` as the transition type, since our screen was presented
         */
        becomeLazy(for: .dismiss)
    }
}

/* 4. Run this playground to see it in action */












































let lazyVC = LazyViewController()
let backVC = BackgroundViewController.instantiate(with: lazyVC, action: { presented, presenting in
    presenting.present(presented, animated: true, completion: nil)
})
backVC.view.frame = .iphone6

PlaygroundPage.current.liveView = backVC.view

lazyVC.view.backgroundColor = .blue

