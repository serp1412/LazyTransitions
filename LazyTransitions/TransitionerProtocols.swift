//
//  TransitionerProtocols.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/2/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

let progressThreshold: CGFloat = 0.3

public protocol TransitionerDelegate: class {
    func finishedInteractiveTransition(_ completed: Bool)
    func beginTransition(with transitioner: Transitioner)
}

public extension TransitionerDelegate {
    func finishedInteractiveTransition(_ completed: Bool) { }
}

public protocol Transitioner: class {
    var animator: TransitionAnimator { get }
    var interactor: TransitionInteractor? { get }
    weak var delegate: TransitionerDelegate? { get set }
}

public protocol InteractiveTransitioner: Transitioner {
    var gestureHandler: TransitionGestureHandler { get }
    init(with gestureHandler: TransitionGestureHandler,
         with animator: TransitionAnimator,
         with interactor: TransitionInteractor)
}

public extension Transitioner {
    var interactor: TransitionInteractor? {
        return nil
    }
}
