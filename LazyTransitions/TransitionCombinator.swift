//
//  TransitionCombinator.swift
//  LazyTransitions
//
//  Created by BeardWare on 12/11/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public class TransitionCombinator: Transitioner {
    public weak var delegate: TransitionerDelegate?
    public var animator: TransitionAnimator  {
        return currentTransitioner?.animator ?? defaultAnimator
    }
    public var interactor: TransitionInteractor? {
        return currentTransitioner?.interactor
    }
    public var allowedOrientations: [TransitionOrientation]? {
        didSet {
            updateAnimatorsAllowedOrientations()
        }
    }
    public private(set) var transitioners: [Transitioner] {
        didSet {
            updateTransitionersDelegate()
            updateAnimatorsAllowedOrientations()
        }
    }
    fileprivate var currentTransitioner: Transitioner?
    fileprivate let defaultAnimator: TransitionAnimator
    fileprivate var delayedRemove: (() -> ())?
    fileprivate var isTransitionInProgress: Bool {
        return currentTransitioner != nil
    }
    
    public convenience init(defaultAnimator: TransitionAnimator = DefaultAnimator(orientation: .topToBottom),
                     transitioners: Transitioner...) {
        self.init(defaultAnimator: defaultAnimator, transitioners: transitioners)
    }
    
    public init(defaultAnimator: TransitionAnimator = DefaultAnimator(orientation: .topToBottom),
         transitioners: [Transitioner]) {
        self.defaultAnimator = defaultAnimator
        self.transitioners = transitioners
        updateTransitionersDelegate()
    }
    
    public func add(_ transitioner: Transitioner) {
        transitioners.append(transitioner)
    }
    
    public func remove(_ transitioner: Transitioner) {
        let remove: (() -> ()) = { [weak self] in
            self?.transitioners = self?.transitioners.filter { $0 !== transitioner } ?? []
        }
        
        isTransitionInProgress ? delayedRemove = remove : remove()
    }
    
    fileprivate func updateTransitionersDelegate() {
        transitioners.forEach{ $0.delegate = self }
    }
    
    fileprivate func updateAnimatorsAllowedOrientations() {
        allowedOrientations.apply { orientations in
            transitioners.forEach { $0.animator.allowedOrientations = orientations }
        }
    }
}

extension TransitionCombinator: TransitionerDelegate {
    public func beginTransition(with transitioner: Transitioner) {
        currentTransitioner = transitioner
        delegate?.beginTransition(with: transitioner)
    }
    
    public func finishedInteractiveTransition(_ completed: Bool) {
        currentTransitioner = nil
        delayedRemove?()
        delayedRemove = nil
        delegate?.finishedInteractiveTransition(completed)
    }
}

extension TransitionCombinator {
    public func add(_ transitioners: [Transitioner]) {
        transitioners.forEach { transitioner in add(transitioner) }
    }
    
    public func remove(_ transitioners: [Transitioner]) {
        transitioners.forEach { transitioner in remove(transitioner) }
    }
}
