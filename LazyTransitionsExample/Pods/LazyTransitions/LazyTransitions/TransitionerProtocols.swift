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
    func beginTransition(with transitioner: TransitionerType)
}

public extension TransitionerDelegate {
    func finishedInteractiveTransition(_ completed: Bool) { }
}

public protocol TransitionerType: class {
    var animator: TransitionAnimatorType { get }
    var interactor: TransitionInteractor? { get }
    var delegate: TransitionerDelegate? { get set }
}

public protocol InteractiveTransitionerType: TransitionerType {
    var gestureHandler: TransitionGestureHandlerType { get }
    init(with gestureHandler: TransitionGestureHandlerType,
         with animator: TransitionAnimatorType,
         with interactor: TransitionInteractor)
}

public extension TransitionerType {
    var interactor: TransitionInteractor? {
        return nil
    }
}
