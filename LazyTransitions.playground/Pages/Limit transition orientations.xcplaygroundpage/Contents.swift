/*:
 # How to limit which transition orientations are allowed
 */


import LazyTransitions
import PlaygroundSupport

/*
 1. Conform the controller you want to become lazy to `LazyScreen`.
 */
class LazyViewController: UIViewController, LazyScreen {
    /* 2. Introduce a new property `transitioner` */
    var transitioner: LazyTransitioner?

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 3. Initialize the transitioner */
        transitioner = .init(lazyScreen: self,
                             transition: .dismiss)

        /*
         4. Asign an array of orientations you want to allow to the `allowedOrientations` of your transitioner.
         Feel free to change the array and see how that changes the interaction
         */
        transitioner?.allowedOrientations = [.topToBottom, .bottomToTop]
    }
}

/* 5. Run the playground to see it in action */




























let backVC = UIViewController()
backVC.view.backgroundColor = .blue

backVC.view.frame = .iphone6

PlaygroundPage.current.liveView = backVC.view
let lazyVC = LazyViewController()
lazyVC.view.backgroundColor = .red

backVC.present(lazyVC, animated: true, completion: nil)
