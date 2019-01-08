/*:
 # How to setup LazyTransitions with a Presentation controller
 */

import LazyTransitions
import UIKit
import WebKit
import PlaygroundSupport

class WebViewController: UIViewController {
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 1. Create a Presentation instance passing in the presentation animator and a closure to create your UIPresentationController.
         Basically, it's exactly what you would do inside the
         `presentationController(forPresented:presenting:source:)`
         delegate method.
         */
        let presentation = Presentation(animator: BottomToTopAnimator()) { presented, presenting, source in

            let presentor = DimmmedBackgroundPresentationController(presentedViewController: presented, presenting: presenting)

            presentor.desiredSize = CGSize(width: source.view.frame.width, height: source.view.frame.height - 200)

            return presentor
        }

        /* 2. Become lazy for dismiss and, in our case, we needed a custom animator when dismissing this controller */
        becomeLazy(for: .dismiss,
                   animator: TopToBottomAnimator(),
                   presentation: presentation)

        /* 3. Add transition for the web view's scroll view */
        addTransition(forScrollView: webView.scrollView,
                      bouncyEdges: false)
    }
}

/* 4. Run the playground to see it in action. You can swipe the card down to dismiss it */

/* **NOTE**: For custom presentations, in most cases you'll need a dismiss and present animators that do the exact opposite of each other. Check the implementations of the animators in this playground to get a better understanding */
/*:
 These are the main use cases for `LazyTransitions`.

 If you'd like to find out if your particular case is supported, feel free to [open an issue in my repo](https://github.com/serp1412/LazyTransitions/issues)
 */

//: [PREVIOUS: Multiple Scroll Views](Multiple%20scroll%20views)









































/* Oh hey there, didn't expect you to scroll down here. You won't find anything special here, just some setup code ☺️ */
extension WebViewController {
    static func instantiate(url: URL, title: String = "") -> WebViewController {
        let webVC = WebViewController()
        let request = URLRequest(url: url)
        webVC.webView.load(request)
        webVC.title = title
        webVC.setup()

        return webVC
    }
}

class TopToBottomAnimator: NSObject, TransitionAnimatorType {
    weak var delegate: TransitionAnimatorDelegate?
    var orientation = TransitionOrientation.topToBottom
    var allowedOrientations: [TransitionOrientation]? = [.topToBottom]

    override convenience init() {
        self.init(orientation: .topToBottom)
    }

    required init(orientation: TransitionOrientation) {
        self.orientation = orientation
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }

        let containerView = transitionContext.containerView

        let animationDuration = transitionDuration(using: transitionContext)

        containerView.addSubview(fromViewController.view)

        let scaleOutTransform = CGAffineTransform(translationX: 0.0, y: fromViewController.view.frame.height)
        let identityTransform = CGAffineTransform.identity
        fromViewController.view.transform = identityTransform


        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            fromViewController.view.transform = scaleOutTransform
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromViewController.view.transform = identityTransform
        }
    }

    func animationEnded(_ transitionCompleted: Bool) {
        delegate?.transitionDidFinish(transitionCompleted)
    }
}

class BottomToTopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }

        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)

        containerView.addSubview(toViewController.view)

        let scaleOutTransform = CGAffineTransform(translationX: 0.0, y: toViewController.view.frame.height)
        let identityTransform = CGAffineTransform.identity
        toViewController.view.transform = scaleOutTransform

        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = identityTransform
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let button = UIButton.tapMe
        view.addSubview(button)
        button.bindToSuperviewCenter()

        button.addTarget(self, action: #selector(openWebViewController), for: .touchUpInside)
    }

    @objc func openWebViewController() {
        let url = URL(string: "https://www.google.com")!
        let navVC = WebViewController.instantiate(url: url, title: "Test")

        present(navVC, animated: true, completion: nil)    }
}

class DimmmedBackgroundPresentationController: UIPresentationController {

    var desiredSize: CGSize?
    var showsDismissButton = false


    fileprivate let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        return view
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setup()
    }

    override func presentationTransitionWillBegin() {
        containerView?.addSubview(dimmingView)

        dimmingView.alpha = 0.0
        presentedView?.layer.cornerRadius = 15
        presentedView?.layer.masksToBounds = true

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let containerViewBounds = containerView?.bounds {
            dimmingView.frame = containerViewBounds
        }

        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero

        guard let containerBounds = containerView?.bounds else {
            return presentedViewFrame
        }

        let contentContainer = presentedViewController
        if let desiredSize = desiredSize {
            let y = contentContainer.view.frame.size.height - desiredSize.height + 200
            presentedViewFrame.size = desiredSize
            presentedViewFrame.origin.x = (contentContainer.view.frame.size.width - desiredSize.width) / 2
            presentedViewFrame.origin.y = y
        } else {
            presentedViewFrame.size = size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)
        }
        presentedViewFrame.size = desiredSize ?? size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)

        return presentedViewFrame
    }
}

private extension DimmmedBackgroundPresentationController {

    func setup() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapRecognizer)
    }

    @objc dynamic func dimmingViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

extension WebViewController {
    func setup() {
        view.addSubview(webView)
        setupConstraints()
    }

    func setupConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

let screen = ViewController()
screen.view.frame = CGRect.init(x: 0, y: 0, width: 750 / 2, height: 1334 / 2)

PlaygroundPage.current.liveView = screen.view
