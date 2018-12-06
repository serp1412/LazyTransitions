//
//  PartialTransitioner.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 11/30/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public class PartialTransitioner: TransitionerType {
    public weak var scrollView: UIScrollView?
    fileprivate var isPartialTransitionPossible: Bool {
        guard let scrollView = scrollView else { return false }
        if lastRecordedSpeed == 0 { return false }
        if scrollView.isSomewhereInVerticalMiddle { return false }
        if scrollView.panGestureRecognizer.state != .possible { return false }
        
        return true
    }
    fileprivate var orientation: TransitionOrientation {
        guard let scrollView = scrollView else { return .topToBottom }
        return scrollView.possibleVerticalOrientation
    }
    fileprivate var lastRecordedSpeed: CGFloat = 0
    fileprivate var lastOffset: CGPoint = .zero
    fileprivate var lastOffsetCapture: TimeInterval = 0
    
    //MARK: Transitioner Protocol
    
    public weak var delegate: TransitionerDelegate?
    public var animator: TransitionAnimatorType {
        return PartialTransitionAnimator(orientation: orientation,
                                         speed: lastRecordedSpeed)
    }
    
    //MARK: Public Methods
    
    public init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    public func scrollViewDidScroll() {
        recalculateScrollSpeed()
        guard isPartialTransitionPossible else { return }
        performPartialTransition()
    }
    
    //MARK: Private Methods
    
    fileprivate func recalculateScrollSpeed() {
        guard let scrollView = scrollView else { return }
        let currentOffset = scrollView.contentOffset
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        let timeDiff = currentTime - lastOffsetCapture
        if timeDiff <= 0.1 { return }
        
        let distance = currentOffset.y - lastOffset.y
        let scrollSpeedNotAbs = (distance * 10) / 1000.0 //in pixels per millisecond
        
        lastRecordedSpeed = fabs(scrollSpeedNotAbs)
        lastOffset = currentOffset
        lastOffsetCapture = currentTime
    }
    
    fileprivate func performPartialTransition() {
        delegate?.beginTransition(with: self)
        delegate?.finishedInteractiveTransition(false)
    }
}
