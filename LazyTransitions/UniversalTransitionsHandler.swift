//
//  UniversalTransitionsHandler.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/29/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public class UniversalTransitionsHandler : NSObject {
    fileprivate typealias TransitionerTuple = (transitioner: Transitioner, view: UIView?)
    
    public var animator: TransitionAnimator {
        return transitionCombinator.animator
    }
    public var interactor: TransitionInteractor? {
        return transitionCombinator.interactor
    }
    public var allowedOrientations: [TransitionOrientation]? {
        didSet {
            transitionCombinator.allowedOrientations = allowedOrientations
        }
    }
    public var triggerTransitionAction: (UniversalTransitionsHandler) -> () = { _ in }
    
    fileprivate let internalAnimator: TransitionAnimator
    fileprivate let internalInteractor: TransitionInteractor
    weak public var delegate: TransitionerDelegate?
    fileprivate var transitionerTuples: [TransitionerTuple] = []
    fileprivate let transitionCombinator: TransitionCombinator
    public init(animator: TransitionAnimator = DefaultAnimator(orientation: .topToBottom),
                interactor: TransitionInteractor = TransitionInteractor.default()) {
        self.internalAnimator = animator
        self.internalInteractor = interactor
        self.transitionCombinator = TransitionCombinator(defaultAnimator: animator)
        super.init()
        transitionCombinator.delegate = self
    }
    
    public func addTransition(forView view: UIView) {
        if transitionerTuples.contains(where: { $0.view === view }) { return }
        let transitioner = createTransitioner(for: view)
        weak var weakView = view
        transitionCombinator.add(transitioner)
        transitionerTuples.append((transitioner, weakView))
    }
    
    public func addTransition(forScrollView scrollView: UIScrollView) {
        if transitionerTuples.contains(where: { $0.view === scrollView }) { return }
        let transitioners = createTransitioners(for: scrollView)
        transitionCombinator.add(transitioners)
        weak var weakView = scrollView
        transitioners.forEach { transitioner in transitionerTuples.append((transitioner, weakView)) }
    }
    
    public func removeTransitions(for view: UIView) {
        let transitioners = self.transitioners(for: view)
        transitionCombinator.remove(transitioners)
        transitionerTuples = transitionerTuples.filter{ $0.view !== view }
    }
    
    public func didScroll(_ scrollView: UIScrollView) {
        let partialTransitioner = self.partialTransitioner(for: scrollView)
        partialTransitioner?.scrollViewDidScroll()
    }
    
    fileprivate func transitioners(for view: UIView) -> [Transitioner] {
        return transitionerTuples
            .filter{$0.view === view}
            .map{$0.transitioner}
    }
    
    fileprivate func partialTransitioner(for scrollView: UIScrollView) -> PartialTransitioner? {
        return transitionerTuples
            .filter{$0.transitioner is PartialTransitioner}
            .map{$0.transitioner as? PartialTransitioner}
            .flatMap{$0}
            .filter{ $0.scrollView === scrollView }
            .lazy.first
    }
    
    fileprivate func createTransitioner(for view: UIView) -> Transitioner {
        let viewGestureHandler = StaticViewTransitionGestureHandler()
        let panGesture = UIPanGestureRecognizer(gestureHandle: { [weak viewGestureHandler] gesture in
            viewGestureHandler?.handlePanGesture(gesture)
        })
        view.addGestureRecognizer(panGesture)
        return DefaultInteractiveTransitioner(with: viewGestureHandler,
                                              with: internalAnimator,
                                              with: internalInteractor)
    }
    
    fileprivate func createTransitioners(for scrollView: UIScrollView) -> [Transitioner] {
        let scrollViewGestureHandler = ScrollableGestureHandler(scrollable: scrollView)
        let scrollViewTransitioner = DefaultInteractiveTransitioner(with: scrollViewGestureHandler,
                                                                    with: internalAnimator,
                                                                    with: internalInteractor)
        scrollView.panGestureRecognizer.set { gesture in
            scrollViewGestureHandler.handlePanGesture(gesture)
        }
        let partialViewTransitioner = PartialTransitioner(scrollView: scrollView)
        
        return [scrollViewTransitioner, partialViewTransitioner]
    }
}

extension UniversalTransitionsHandler: TransitionerDelegate {
    public func beginTransition(with transitioner: Transitioner) {
        triggerTransitionAction(self)
    }
}

extension UniversalTransitionsHandler : UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor
    }
}

extension UniversalTransitionsHandler : UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .pop else { return nil }
        return animator
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor
    }
}
