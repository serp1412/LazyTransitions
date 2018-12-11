//
//  LazyTransitioner.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/29/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

fileprivate enum TransitionType {
    case forScrollView
    case forStaticView
}

public class LazyTransitioner : NSObject {
    fileprivate typealias TransitionerTuple = (transitioner: TransitionerType, view: UIView?, type: TransitionType)

    public var onCompleteTransition: () -> () = {}

    public var animator: TransitionAnimatorType {
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
    public var triggerTransitionAction: (LazyTransitioner) -> () = { _ in }
    
    fileprivate let internalAnimator: TransitionAnimatorType
    fileprivate let internalInteractor: TransitionInteractor
    fileprivate var transitionerTuples: [TransitionerTuple] = []
    fileprivate let transitionCombinator: TransitionCombinator
    public init(animator: TransitionAnimatorType = DismissAnimator(orientation: .topToBottom),
                interactor: TransitionInteractor = TransitionInteractor.default()) {
        self.internalAnimator = animator
        self.internalInteractor = interactor
        self.transitionCombinator = TransitionCombinator(defaultAnimator: animator)
        super.init()
        transitionCombinator.delegate = self
    }
    
    public func addTransition(forView view: UIView) {
        if transitionerTuples.contains(where: { $0.view === view && $0.type == .forStaticView }) { return }
        let transitioner = createTransitioner(for: view)
        weak var weakView = view
        transitionCombinator.add(transitioner)
        transitionerTuples.append((transitioner, weakView, .forStaticView))
    }
    
    public func addTransition(forScrollView scrollView: UIScrollView) {
        if transitionerTuples.contains(where: { $0.view === scrollView && $0.type == .forScrollView }) { return }
        let transitioners = createTransitioners(for: scrollView)
        transitionCombinator.add(transitioners)
        weak var weakView = scrollView
        transitioners.forEach { transitioner in transitionerTuples.append((transitioner, weakView, .forScrollView)) }
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
    
    fileprivate func transitioners(for view: UIView) -> [TransitionerType] {
        return transitionerTuples
            .filter{$0.view === view}
            .map{$0.transitioner}
    }
    
    fileprivate func partialTransitioner(for scrollView: UIScrollView) -> PartialTransitioner? {
        return transitionerTuples
            .filter{$0.transitioner is PartialTransitioner}
            .map{$0.transitioner as? PartialTransitioner}
            .compactMap{$0}
            .filter{ $0.scrollView === scrollView }
            .lazy.first
    }
    
    fileprivate func createTransitioner(for view: UIView) -> TransitionerType {
        let viewGestureHandler = StaticViewGestureHandler()
        let panGesture = UIPanGestureRecognizer(gestureHandle: { [weak viewGestureHandler] gesture in
            viewGestureHandler?.handlePanGesture(gesture)
        })
        view.addGestureRecognizer(panGesture)
        return InteractiveTransitioner(with: viewGestureHandler,
                                       with: internalAnimator,
                                       with: internalInteractor)
    }
    
    fileprivate func createTransitioners(for scrollView: UIScrollView) -> [TransitionerType] {
        let scrollViewGestureHandler = ScrollableGestureHandler(scrollable: scrollView)
        let scrollViewTransitioner = InteractiveTransitioner(with: scrollViewGestureHandler,
                                                             with: internalAnimator,
                                                             with: internalInteractor)
        scrollView.panGestureRecognizer.set { gesture in
            scrollViewGestureHandler.handlePanGesture(gesture)
        }
        let partialViewTransitioner = PartialTransitioner(scrollView: scrollView)
        
        return [scrollViewTransitioner, partialViewTransitioner]
    }
}

extension LazyTransitioner: TransitionerDelegate {
    public func beginTransition(with transitioner: TransitionerType) {
        triggerTransitionAction(self)
    }

    public func finishedInteractiveTransition(_ completed: Bool) {
        onCompleteTransition()
    }
}

extension LazyTransitioner : UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor
    }
}

extension LazyTransitioner : UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .pop else { return nil }
        return animator
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor
    }
}
