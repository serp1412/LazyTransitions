//
//  ScrollableProtocol.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 1/2/17.
//  Copyright © 2017 YOPESO. All rights reserved.
//

import Foundation

protocol Scrollable: class {
    var isAtTop: Bool { get }
    var isAtBottom: Bool { get }
    var isAtLeftEdge: Bool { get }
    var isAtRightEdge: Bool { get }
    var isSomeWhereInVerticalMiddle: Bool { get }
    var isSomeWhereInHorizontalMiddle: Bool { get }
    var bounces: Bool { get set }
}

extension Scrollable {
    var possibleVerticalOrientation: TransitionOrientation {
        return isAtTop ? .topToBottom : .bottomToTop
    }
    
    var possibleHorizontalOrientation: TransitionOrientation {
        return isAtLeftEdge ? .leftToRight : .rightToLeft
    }
    
    var scrollsHorizontally: Bool {
        return !(isAtRightEdge && isAtLeftEdge)
    }
    
    var scrollsVertically: Bool {
        return !(isAtTop && isAtBottom)
    }
}
