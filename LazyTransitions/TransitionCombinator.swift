//
//  TransitionCombinator.swift
//  Wadi
//
//  Created by Yopeso on 12/11/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

class TransitionCombinator: Transitioner {
    weak var delegate: TransitionerDelegate?
    var animator: TransitionAnimator  {
        return currentTransitioner?.animator ?? defaultAnimator
    }
    var interactor: TransitionInteractor? {
        return currentTransitioner?.interactor
    }
    var allowedOrientations: [TransitionOrientation]? {
        didSet {
            updateAnimatorsAllowedOrientations()
        }
    }
    private(set) var transitioners: [Transitioner] {
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
    convenience init(defaultAnimator: TransitionAnimator = DefaultAnimator(orientation: .topToBottom),
                     transitioners: Transitioner...) {
        self.init(defaultAnimator: defaultAnimator, transitioners: transitioners)
    }
    
    init(defaultAnimator: TransitionAnimator = DefaultAnimator(orientation: .topToBottom),
         transitioners: [Transitioner]) {
        self.defaultAnimator = defaultAnimator
        self.transitioners = transitioners
        updateTransitionersDelegate()
    }
    
    func add(_ transitioner: Transitioner) {
        transitioners.append(transitioner)
    }
    
    func remove(_ transitioner: Transitioner) {
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
    func beginTransition(with transitioner: Transitioner) {
        currentTransitioner = transitioner
        delegate?.beginTransition(with: transitioner)
    }
    
    func finishedInteractiveTransition(_ completed: Bool) {
        currentTransitioner = nil
        delayedRemove?()
        delayedRemove = nil
        delegate?.finishedInteractiveTransition(completed)
    }
}

extension TransitionCombinator {
    func add(_ transitioners: [Transitioner]) {
        transitioners.forEach { transitioner in add(transitioner) }
    }
    
    func remove(_ transitioners: [Transitioner]) {
        transitioners.forEach { transitioner in remove(transitioner) }
    }
}
