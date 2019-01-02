/*:
 # How to add a lazy Pop Animation
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

        /*
         3. Initialize the transitioner by passing `self` as the lazy screen and providing `.pop` as the transition type, since our screen is in a navigation stack
         */
        transitioner = .init(lazyScreen: self, transition: .pop)
    }
}

// 4. Run the Playground to see how it works
































let nav = UINavigationController()
nav.view.frame = .iphone6

let lazyVC = LazyViewController()
let backVC = BackgroundViewController.instantiate(with: lazyVC, action: { presented, presenting in

    presenting.navigationController?.pushViewController(presented, animated: true)
    presented.view.backgroundColor = .blue
})

nav.pushViewController(backVC, animated: false)

PlaygroundPage.current.liveView = nav.view


/*
 Add swipe direction hint on lazyVC
 LazyTransitioner in a runtime attribute
 Override scroll view delegate using runtime
 Write README in playgrounds
 Delete Example project
 Delete Xcode10Playground
 Update README in repository
 */
