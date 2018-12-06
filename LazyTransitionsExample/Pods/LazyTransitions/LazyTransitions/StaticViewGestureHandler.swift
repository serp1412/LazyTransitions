//
//  StaticViewGestureHandler.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/6/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public class StaticViewGestureHandler: TransitionGestureHandlerType {
    public var shouldFinish: Bool = false
    public var didBegin: Bool = false
    public var inProgressTransitionOrientation = TransitionOrientation.unknown
    public weak var delegate: TransitionGestureHandlerDelegate?
    
    public init() {}
    
    public func didBegin(_ gesture: UIPanGestureRecognizer) {
        inProgressTransitionOrientation = gesture.direction.orientation
        didBegin = true
        delegate?.beginInteractiveTransition(with: inProgressTransitionOrientation)
    }
    
    public func didChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let progress = calculateTransitionProgressWithTranslation(translation, on: gesture.view)
        shouldFinish = progress > progressThreshold
        delegate?.updateInteractiveTransitionWithProgress(progress)
    }
    
    public func calculateTransitionProgressWithTranslation(_ translation: CGPoint, on view: UIView?) -> CGFloat {
        
        guard let view = view else { return 0 }
        
        let progress = TransitionProgressCalculator
            .progress(for: view,
                      withGestureTranslation: translation,
                      withTranslationOffset: .zero,
                      with: inProgressTransitionOrientation)
        
        return progress
    }
}

extension UIPanGestureRecognizerDirection {
    public var orientation: TransitionOrientation {
        switch self {
        case .rightToLeft: return .rightToLeft
        case .leftToRight: return .leftToRight
        case .bottomToTop: return .bottomToTop
        case .topToBottom: return .topToBottom
        default: return .unknown
        }
    }
}

extension UIPanGestureRecognizerDirection {
    public var isHorizontal: Bool {
        switch self {
        case .rightToLeft, .leftToRight:
            return true
        default:
            return false
        }
    }
}
