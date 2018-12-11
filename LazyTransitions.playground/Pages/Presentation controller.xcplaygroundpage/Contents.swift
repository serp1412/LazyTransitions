import LazyTransitions
import UIKit
import PlaygroundSupport

final class WebViewController: UIViewController {

    let webView: UIWebView = {
        let webView = UIWebView()
        webView.scalesPageToFit = true

        return webView
    }()


    init(url: URL, title: String = "") {
        super.init(nibName: nil, bundle: nil)

        self.edgesForExtendedLayout = []

        let request = URLRequest(url: url)
        self.webView.loadRequest(request)

        self.title = title

        self.setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.view.addSubview(self.webView)

        self.setupConstraints()
    }

    func setupConstraints() {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

final class BottomUpTransition: NSObject, TransitionAnimatorType {

    // MARK: Added to convert to a LazyTransition
    public weak var delegate: TransitionAnimatorDelegate?
    public var orientation = TransitionOrientation.topToBottom
    public var allowedOrientations: [TransitionOrientation]? = [TransitionOrientation.topToBottom]

    public required init(orientation: TransitionOrientation) {
        self.orientation = orientation
        self.isReversed = true
        self.animationDuration = 0.3
    }

    // MARK: Begin original code

    let isReversed: Bool
    let animationDuration: TimeInterval

    init(isReversed: Bool, duration: TimeInterval) {
        self.isReversed = isReversed
        self.animationDuration = duration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }

        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }

        let animatingViewController = self.isReversed ? fromViewController : toViewController

        let containerView = transitionContext.containerView

        let animationDuration = self.transitionDuration(using: transitionContext)

        containerView.addSubview(animatingViewController.view)

        let scaleOutTransform = CGAffineTransform(translationX: 0.0, y: animatingViewController.view.frame.height)
        let identityTransform = CGAffineTransform.identity
        animatingViewController.view.transform = self.isReversed ? identityTransform : scaleOutTransform


        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            animatingViewController.view.transform = self.isReversed ? scaleOutTransform : identityTransform
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if self.isReversed {
                animatingViewController.view.transform = identityTransform
            }
        }
    }

    func animationEnded(_ transitionCompleted: Bool) {
        delegate?.transitionDidFinish(transitionCompleted)
    }
}

class ViewController: UIViewController {

    fileprivate let transitioner = LazyTransitioner(animator: BottomUpTransition(isReversed: true, duration: 0.3))

    let button: UIButton = {
        let button = UIButton(type: .system)

        button.backgroundColor = UIColor.red
        button.setTitle("Tap me!", for: .normal)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.button)

        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: 200.0).isActive = true

        self.button.addTarget(self, action: #selector(openWebViewController), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


   @objc func openWebViewController() {
        let url = URL(string: "https://www.google.com")!
        let webViewController = WebViewController(url: url, title: "Test")

        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .custom

        transitioner.addTransition(forScrollView: webViewController.webView.scrollView)
        transitioner.addTransition(forView: webViewController.view)
        transitioner.triggerTransitionAction = { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        navigationController.transitioningDelegate = self

        self.present(navigationController, animated: true, completion: nil)    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitioner.animator
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomUpTransition(isReversed: false, duration: 0.3)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitioner.interactor
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentor = DimmmedBackgroundPresentationController(presentedViewController: presented, presenting: presenting)

        presentor.desiredSize = CGSize(width: view.frame.width, height: view.frame.height - 200)

        return presentor
    }
}


final class DimmmedBackgroundPresentationController: UIPresentationController {

    var desiredSize: CGSize?
    var showsDismissButton = false


    fileprivate let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.alpha = 0.6
        view.addSubview(visualEffectView)

        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        return view
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        self.setup()
    }

    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(self.dimmingView)

        self.dimmingView.alpha = 0.0

        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let containerViewBounds = self.containerView?.bounds {
            self.dimmingView.frame = containerViewBounds
        }

        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero

        guard let containerBounds = containerView?.bounds else {
            return presentedViewFrame
        }

        let contentContainer = self.presentedViewController
        if let desiredSize = self.desiredSize {
            let y = contentContainer.view.frame.size.height - desiredSize.height + 200
            presentedViewFrame.size = desiredSize
            presentedViewFrame.origin.x = (contentContainer.view.frame.size.width - desiredSize.width) / 2
            presentedViewFrame.origin.y = y
            contentContainer.view.frame
            desiredSize
            presentedViewFrame
        } else {
            presentedViewFrame.size = self.size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)
        }
        presentedViewFrame.size = self.desiredSize ?? self.size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)

        return presentedViewFrame
    }
}

private extension DimmmedBackgroundPresentationController {

    func setup() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dimmingViewTapped))
        self.dimmingView.addGestureRecognizer(tapRecognizer)
    }

    @objc dynamic func dimmingViewTapped() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}

let screen = ViewController()
screen.view.frame = CGRect.init(x: 0, y: 0, width: 750 / 2, height: 1334 / 2)

PlaygroundPage.current.liveView = screen.view
