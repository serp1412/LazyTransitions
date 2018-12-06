//
//  UIScrollViewExtensions.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 11/25/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

extension UIScrollView: Scrollable {
    public var isAtTop: Bool {
        return (contentOffset.y + contentInset.top) == 0
    }
    
    public var isAtBottom: Bool {
        let scrollOffset = Int(contentOffset.y)
        let height = Int(frame.height)
        let contentHeight = Int(contentSize.height)
        
        return scrollOffset + height >= contentHeight
    }
    
    public var isSomewhereInVerticalMiddle: Bool {
        return !isAtTop && !isAtBottom
    }
    
    public var isAtLeftEdge: Bool {
        return (contentOffset.x + contentInset.left) == 0
    }
    
    public var isAtRightEdge: Bool {
        let scrollOffset = Int(contentOffset.x)
        let width = Int(frame.width)
        let contentWidth = Int(contentSize.width)
        
        return scrollOffset + width >= contentWidth
    }
    
    public var isSomewhereInHorizontalMiddle: Bool {
        return !isAtLeftEdge && !isAtRightEdge
    }
}
