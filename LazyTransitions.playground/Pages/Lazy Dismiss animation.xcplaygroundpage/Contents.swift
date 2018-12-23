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
class LazyViewController: UIViewController, LazyScreen {
    
    /* 2. Introduce a new property, it can be optional or IUO */
    var transitioner: LazyTransitioner?

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 3. Initialize the transitioner by passing `self` as the lazy screen and providing `.dismiss` as the transition type, since our screen was presented
         */
        transitioner = .init(lazyScreen: self, transition: .dismiss)
    }
}

/* 4. Run this playground to see it in action */

















let backVC = UIViewController()
backVC.view.backgroundColor = .blue

backVC.view.frame = .iphone6

PlaygroundPage.current.liveView = backVC.view
let lazyVC = LazyViewController()
lazyVC.view.backgroundColor = .red

backVC.present(lazyVC, animated: true, completion: nil)
