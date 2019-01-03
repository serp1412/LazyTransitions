/*:
 # How to limit which transition orientations are allowed
 */


import LazyTransitions
import PlaygroundSupport

/*
 1. Conform the controller you want to become lazy to `LazyScreen`.
 */
class LazyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 3. Initialize the transitioner */
        becomeLazy(for: .dismiss)

        /*
         4. Asign an array of orientations you want to allow to the `allowedOrientations` of your transitioner.
         Feel free to change the array and see how that changes the interaction
         */
        transitioner?.allowedOrientations = [.topToBottom, .bottomToTop]
    }
}

/* 5. Run the playground to see it in action */



























let lazyVC = LazyViewController()
let backVC = BackgroundViewController.instantiate(with: lazyVC, action: { presented, presenting in
    presenting.present(presented, animated: true, completion: nil)
})
backVC.view.frame = .iphone6
lazyVC.view.backgroundColor = .blue

PlaygroundPage.current.liveView = backVC.view

