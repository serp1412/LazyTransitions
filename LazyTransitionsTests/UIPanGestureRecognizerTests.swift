//
//  UIPanGestureRecognizerTests.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/9/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import XCTest
@testable import LazyTransitions

class UIPanGestureRecognizerTests: XCTestCase {
    var mockGesture: MockPanGestureRecognizer!
    
    override func setUp() {
        mockGesture = MockPanGestureRecognizer()
    }
    
    func testDirection_bottomToTop() {
        mockGesture.mockVelocity = CGPoint(x: 10, y: -20)
        
        XCTAssert(mockGesture.direction == .bottomToTop)
    }
    
    func testDirection_topToBottom() {
        mockGesture.mockVelocity = CGPoint(x: 10, y: 20)
        
        XCTAssert(mockGesture.direction == .topToBottom)
    }
    
    func testDirection_rightToLeft() {
        mockGesture.mockVelocity = CGPoint(x: -20, y: 10)
        
        XCTAssert(mockGesture.direction == .rightToLeft)
    }
    
    func testDirection_leftToRight() {
        mockGesture.mockVelocity = CGPoint(x: 20, y: 10)
        
        XCTAssert(mockGesture.direction == .leftToRight)
    }
    
    func testIsQuickSwipeForOrientation_Unknown() {
        XCTAssert(!mockGesture.isQuickSwipe(for: .unknown))
    }
    
    func testIsQuickSwipeForOrientation_TopToBottom_False() {
        mockGesture.mockVelocity = CGPoint(x: 0, y: 500)
        
        XCTAssert(!mockGesture.isQuickSwipe(for: .topToBottom))
    }
    
    func testIsQuickSwipeForOrientation_TopToBottom_True() {
        mockGesture.mockVelocity = CGPoint(x: 0, y: 1002)
        
        XCTAssert(mockGesture.isQuickSwipe(for: .topToBottom))
    }
    
    func testIsQuickSwipeForOrientation_BottomToTop_False() {
        mockGesture.mockVelocity = CGPoint(x: 0, y: -500)
        
        XCTAssert(!mockGesture.isQuickSwipe(for: .bottomToTop))
    }
    
    func testIsQuickSwipeForOrientation_BottomToTop_True() {
        mockGesture.mockVelocity = CGPoint(x: 0, y: -1002)
        
        XCTAssert(mockGesture.isQuickSwipe(for: .bottomToTop))
    }
    
    func testIsQuickSwipeForOrientation_LeftToRight_False() {
        mockGesture.mockVelocity = CGPoint(x: 500, y: 0)
        
        XCTAssert(!mockGesture.isQuickSwipe(for: .leftToRight))
    }
    
    func testIsQuickSwipeForOrientation_LeftToRight_True() {
        mockGesture.mockVelocity = CGPoint(x: 1002, y: 0)
        
        XCTAssert(mockGesture.isQuickSwipe(for: .leftToRight))
    }
    
    func testIsQuickSwipeForOrientation_RightToLeft_False() {
        mockGesture.mockVelocity = CGPoint(x: -500, y: 0)
        
        XCTAssert(!mockGesture.isQuickSwipe(for: .rightToLeft))
    }
    
    func testIsQuickSwipeForOrientation_RightToLeft_True() {
        mockGesture.mockVelocity = CGPoint(x: -1002, y: 0)
        
        XCTAssert(mockGesture.isQuickSwipe(for: .rightToLeft))
    }
    
    func testIsHorizontal_LeftToRight_True() {
        mockGesture.mockVelocity = CGPoint(x: 40, y: 10)
        
        XCTAssert(mockGesture.direction.isHorizontal)
    }
    
    func testIsHorizontal_RightToLeft_True() {
        mockGesture.mockVelocity = CGPoint(x: -40, y: 10)
        
        XCTAssert(mockGesture.direction.isHorizontal)
    }
    
    func testIsHorizontal_TopToBottom_False() {
        mockGesture.mockVelocity = CGPoint(x: 10, y: 40)
        
        XCTAssertFalse(mockGesture.direction.isHorizontal)
    }
    
    func testIsHorizontal_BottomToTop_False() {
        mockGesture.mockVelocity = CGPoint(x: 10, y: -40)
        
        XCTAssertFalse(mockGesture.direction.isHorizontal)
    }
}
