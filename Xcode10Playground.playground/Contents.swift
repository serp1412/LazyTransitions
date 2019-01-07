import UIKit
import PlaygroundSupport

class SomeController: UIViewController, UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("was called")
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("was called")
    }
}

let vc = SomeController()
let nav = UINavigationController.init(rootViewController: vc)

let otherVC = UIViewController()
otherVC.view.backgroundColor = .red


PlaygroundPage.current.liveView = nav.view

vc.navigationController?.delegate = vc

nav.pushViewController(otherVC, animated: true)
