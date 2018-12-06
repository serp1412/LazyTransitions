//
//  TransitionAnimatorType.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 11/24/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public protocol TransitionAnimatorType : UIViewControllerAnimatedTransitioning {
    var delegate: TransitionAnimatorDelegate? { get set }
    var orientation: TransitionOrientation { get set }
    init(orientation: TransitionOrientation)
    var supportedOrientations: [TransitionOrientation] { get }
    var allowedOrientations: [TransitionOrientation]? { get set }
}

extension TransitionAnimatorType {
    public var supportedOrientations: [TransitionOrientation] {
        return [.topToBottom, .bottomToTop, .leftToRight, .rightToLeft]
    }
    
    public var isOrientationAllowed: Bool {
        return allowedOrientations?.contains(orientation) ?? true
    }
    
    public var isOrientationSupported: Bool {
        return supportedOrientations.contains(orientation)
    }
}

public protocol TransitionAnimatorDelegate: class {
    func transitionDidFinish(_ completed: Bool)
}

extension TransitionAnimatorType {
    public func finalFrame(for view: UIView, for orientation: TransitionOrientation) -> CGRect {
        let size = view.frame.size
        switch orientation {
        case .topToBottom:
            let bottomLeftCorner = CGPoint(x: view.frame.origin.x, y: size.height)
            return CGRect(origin: bottomLeftCorner, size: size)
        case .bottomToTop:
            let upperLeftCorner = CGPoint(x: view.frame.origin.x, y: -size.height)
            return CGRect(origin: upperLeftCorner, size: size)
        case .leftToRight:
            let topRightCorner = CGPoint(x: size.width, y: view.frame.origin.y)
            return CGRect(origin: topRightCorner, size: size)
        case .rightToLeft:
            let topLeftCorner = CGPoint(x: -size.width, y: view.frame.origin.y)
            return CGRect(origin: topLeftCorner, size: size)
        default: return view.frame
        }
    }
}
