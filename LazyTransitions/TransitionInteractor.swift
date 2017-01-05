//
//  Interactor.swift
//  InteractiveModal
//
//  Created by Robert Chen on 1/18/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit

public class TransitionInteractor: UIPercentDrivenInteractiveTransition {
    func setCompletionSpeedForFinish() {
        completionSpeed = 1.0
    }
    
    func setCompletionSpeedForCancel() {
        // if completionSpeed is not of the default value in iOS 8 it will show a jerky visual glitch.
        completionSpeed = isiOS9 ? 0.5 : 1.0
    }
    
    static func `default`() -> TransitionInteractor {
        let transitionInteractor = TransitionInteractor()
        transitionInteractor.completionCurve = .easeInOut
        return transitionInteractor
    }
    
    fileprivate var isiOS9: Bool {
        return ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 9, minorVersion: 0, patchVersion: 0))
    }
}
