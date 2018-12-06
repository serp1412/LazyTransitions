//
//  TransitionProgressCalculator.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/2/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

public enum TransitionOrientation {
    case unknown
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
}

public struct TransitionProgressCalculator {
    public static func progress(for view: UIView,
                         withGestureTranslation translation: CGPoint,
                         withTranslationOffset translationOffset: CGPoint,
                         with orientation: TransitionOrientation) -> CGFloat {
        var progress:Float = 0
        
        let adjustedTranslation = translation - translationOffset
        
        switch orientation {
        case .topToBottom:
            let verticalMovement = Float(adjustedTranslation.y / view.bounds.height)
            let downwardMovement = fmaxf(verticalMovement, 0.0)
            progress = fminf(downwardMovement, 1.0)
        case .bottomToTop:
            let verticalMovement = Float(adjustedTranslation.y / view.bounds.height)
            let upwardMovement = abs(fminf(verticalMovement, 0.0))
            progress = fminf(upwardMovement, 1.0)
        case .leftToRight:
            let horizontalMovement = Float(adjustedTranslation.x / view.bounds.width)
            let leftToRightMovement = fmaxf(horizontalMovement, 0.0)
            progress = fminf(leftToRightMovement, 1.0)
        case .rightToLeft:
            let horizontalMovement = Float(adjustedTranslation.x / view.bounds.width)
            let rightToLeftMovement = abs(fminf(horizontalMovement, 0))
            progress = fminf(rightToLeftMovement, 1)
        default: break
        }
        
        return CGFloat(progress)
    }
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
