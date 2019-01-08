/*:
 # How to limit which transition orientations are allowed
 */


import LazyTransitions
import PlaygroundSupport

class LazyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 1. Become lazy for your transition type */
        becomeLazy(for: .dismiss)

        /*
         2. Provide the orientations that you'd like to allow

         **NOTE** if your transition animator doesn't support the orientation that you provide, it'll be ignored.
         */
        allowedOrientations = [.topToBottom, .bottomToTop]
    }
}

/*
 3. Run the playground to see it in action

 Vertical swipes should dismiss the screen.
 While horizontal ones should be ignored
 */

//: [NEXT: Bouncy Scroll View Animation](Bouncy%20ScrollView%20animation)       [PREVIOUS: Lazy Pop Animation](Lazy%20Pop%20animation)

































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

