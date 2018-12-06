import LazyTransitions
import PlaygroundSupport

let transitioner = LazyTransitioner()

let frontVC = UIViewController()
let backVC = UIViewController()
frontVC.view.backgroundColor = .red
backVC.view.backgroundColor = .blue
frontVC.transitioningDelegate = transitioner
let nav = UINavigationController.init(rootViewController: backVC)

nav.delegate = transitioner
transitioner.addTransition(forView: frontVC.view)

transitioner.triggerTransitionAction = { transitioner in
    nav.popViewController(animated: true)
}

nav.view.frame = CGRect.init(x: 0, y: 0, width: 750 / 2, height: 1334 / 2)

PlaygroundPage.current.liveView = nav.view

nav.pushViewController(frontVC, animated: true)
