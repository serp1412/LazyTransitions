import LazyTransitions
import PlaygroundSupport

class LazyViewController: UIViewController {
    let transitioner = LazyTransitioner()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        transitioner.addTransition(forView: view)

        transitioner.triggerTransitionAction = { [weak self] transitioner in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationController?.delegate = transitioner
    }
}

let backVC = UIViewController()
backVC.view.backgroundColor = .blue

let nav = UINavigationController.init(rootViewController: backVC)

nav.view.frame = CGRect.init(x: 0, y: 0, width: 750 / 2, height: 1334 / 2)

PlaygroundPage.current.liveView = nav.view

nav.pushViewController(LazyViewController(), animated: true)

/*
 Dismiss
 Pop
 Bouncy scroll view
 Limit orientations
 Presentation controller
 Multiple scroll views
 Custom transitioners??

 */
