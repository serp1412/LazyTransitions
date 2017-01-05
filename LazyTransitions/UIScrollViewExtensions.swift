//
//  UIScrollViewExtensions.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 11/25/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

extension UIScrollView: Scrollable {
    var isAtTop: Bool {
        return contentOffset.y == 0
    }
    
    var isAtBottom: Bool {
        let scrollOffset = Int(contentOffset.y)
        let height = Int(frame.height)
        let contentHeight = Int(contentSize.height)
        
        return scrollOffset + height >= contentHeight
    }
    
    var isSomeWhereInVerticalMiddle: Bool {
        return !isAtTop && !isAtBottom
    }
    
    var isAtLeftEdge: Bool {
        return contentOffset.x == 0
    }
    
    var isAtRightEdge: Bool {
        let scrollOffset = Int(contentOffset.x)
        let width = Int(frame.width)
        let contentWidth = Int(contentSize.width)
        
        return scrollOffset + width >= contentWidth
    }
    
    var isSomeWhereInHorizontalMiddle: Bool {
        return !isAtLeftEdge && !isAtRightEdge
    }
}
