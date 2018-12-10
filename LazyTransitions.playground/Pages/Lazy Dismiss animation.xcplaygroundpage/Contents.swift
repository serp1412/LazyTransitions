import LazyTransitions
import PlaygroundSupport


class LazyViewController: UIViewController {
    let transitioner = LazyTransitioner()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        transitioningDelegate = transitioner
        transitioner.addTransition(forView: view)

        transitioner.triggerTransitionAction = { [weak self] transitioner in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

let backVC = UIViewController()
backVC.view.backgroundColor = .blue

backVC.view.frame = CGRect.init(x: 0, y: 0, width: 750 / 2, height: 1334 / 2)

PlaygroundPage.current.liveView = backVC.view

backVC.present(LazyViewController(), animated: true, completion: nil)
