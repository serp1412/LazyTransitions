//
//  ScrollableGestureHandlerTests.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/30/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import XCTest
@testable import LazyTransitions

class MockScrollable: Scrollable {
    var mockIsAtTop: Bool = false
    var mockIsAtBottom: Bool = false
    var mockIsInVerticalMiddle: Bool = false
    var mockIsAtLeftEdge: Bool = false
    var mockIsAtRightEdge: Bool = false
    var mockIsInHorizontalMiddle: Bool = false
    
    var bounces: Bool = true
    
    var isAtTop: Bool {
        return mockIsAtTop
    }
    
    var isAtBottom: Bool {
        return mockIsAtBottom
    }
    
    var isSomewhereInVerticalMiddle: Bool {
        return mockIsInVerticalMiddle
    }
    
    var isAtLeftEdge: Bool {
        return mockIsAtLeftEdge
    }
    
    var isAtRightEdge: Bool {
        return mockIsAtRightEdge
    }
    
    var isSomewhereInHorizontalMiddle: Bool {
        return mockIsInHorizontalMiddle
    }
}

class ScrollableGestureHandlerTests: XCTestCase {
    let mockGesture: MockPanGestureRecognizer = MockPanGestureRecognizer()
    let mockHandlerDelegate: MockGestureHandlerDelegate = MockGestureHandlerDelegate()
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
    var mockScrollable = MockScrollable()
    var handler: ScrollableGestureHandler!
    
    override func setUp() {
        mockGesture.mockState = .possible
        mockGesture.mockVelocity = .zero
        mockGesture.mockView = UIView()
        mockGesture.mockTranslation = .zero
        
        mockScrollable = MockScrollable()
        
        mockHandlerDelegate.beginCalled = BeginWithOrientationCalled()
        mockHandlerDelegate.updateCalled = UpdateWithProgressCalled()
        mockHandlerDelegate.finishCalled = false
        mockHandlerDelegate.cancelCalled = false
        
        handler = ScrollableGestureHandler(scrollable: mockScrollable)
        handler.delegate = mockHandlerDelegate
        handler.shouldFinish = false
        handler.inProgressTransitionOrientation = .unknown
    }
    
    func testBounceSetToFalse() {
        XCTAssert(mockScrollable.bounces == false)
    }
    
    func testHandlePanGesture_StateChanged_ShouldNotBegin_WhenInBothOrientationMiddles() {
        mockScrollable.mockIsInVerticalMiddle = true
        mockScrollable.mockIsInHorizontalMiddle = true
        
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.wasCalled == false)
        XCTAssert(handler.didBegin == false)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_WhenJustInVerticalMiddle() {
        mockScrollable.mockIsInVerticalMiddle = true
        mockScrollable.mockIsInHorizontalMiddle = false
        handler.didBegin = false
        
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.wasCalled == true)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_WhenJustInHorizontalMiddle() {
        mockScrollable.mockIsInVerticalMiddle = false
        mockScrollable.mockIsInHorizontalMiddle = true
        handler.didBegin = false
        
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.wasCalled == true)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_TopToBottom_WhenInHorizontalMiddle() {
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsInHorizontalMiddle = true
        
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .topToBottom)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_TopToBottom_WhenAtLeftEdge() {
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtLeftEdge = true
        mockGesture.mockVelocity = .downwardPanVelocity
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .topToBottom)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_TopToBottom_WhenAtRightEdge() {
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtRightEdge = true
        mockGesture.mockVelocity = .downwardPanVelocity
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .topToBottom)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_TopToBottom_WhenDoesntScrollHorizontally() {
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtRightEdge = true
        mockScrollable.mockIsAtLeftEdge = true
        mockGesture.mockVelocity = CGPoint(x: 20, y: 10)
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .topToBottom)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_BottomToTop_WhenDoesntScrollHorizontally() {
        mockScrollable.mockIsAtBottom = true
        mockScrollable.mockIsAtRightEdge = true
        mockScrollable.mockIsAtLeftEdge = true
        mockGesture.mockVelocity = CGPoint(x: 20, y: -10)
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .bottomToTop)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_LeftToRight_WhenDoesntScrollVertically() {
        mockScrollable.mockIsAtLeftEdge = true
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtBottom = true
        mockGesture.mockVelocity = CGPoint(x: 10, y: 20)
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .leftToRight)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_RightToLeft_WhenDoesntScrollVertically() {
        mockScrollable.mockIsAtRightEdge = true
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtBottom = true
        mockGesture.mockVelocity = CGPoint(x: -10, y: 20)
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .rightToLeft)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_BottomToTop_WhenInHorizontalMiddle() {
        mockScrollable.mockIsAtBottom = true
        mockScrollable.mockIsInHorizontalMiddle = true

        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .bottomToTop)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_BottomToTop_WhenAtLeftEdge() {
        mockScrollable.mockIsAtBottom = true
        mockScrollable.mockIsAtLeftEdge = true
        mockGesture.mockVelocity = .upwardPanVelocity
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .bottomToTop)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_BottomToTop_WhenAtRightEdge() {
        mockScrollable.mockIsAtBottom = true
        mockScrollable.mockIsAtRightEdge = true
        mockGesture.mockVelocity = .upwardPanVelocity
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .bottomToTop)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_LeftToRight_WhenInVerticalMiddle() {
        mockScrollable.mockIsAtLeftEdge = true
        mockScrollable.mockIsInVerticalMiddle = true
        
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .leftToRight)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_LeftToRight_WhenAtTopEdge() {
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtLeftEdge = true
        mockGesture.mockVelocity = .toTheRightVelocity
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .leftToRight)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_LeftToRight_WhenAtBottomEdge() {
        mockScrollable.mockIsAtBottom = true
        mockScrollable.mockIsAtLeftEdge = true
        mockGesture.mockVelocity = .toTheRightVelocity
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .leftToRight)
        XCTAssert(handler.didBegin == true)
    }
    
    
    func testHandlePanGesture_StateChanged_ShouldBegin_RightToLeft_WhenInVerticalMiddle() {
        mockScrollable.mockIsAtRightEdge = true
        mockScrollable.mockIsInVerticalMiddle = true
        
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .rightToLeft)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_RightToLeft_WhenAtTopEdge() {
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtRightEdge = true
        mockGesture.mockVelocity = .toTheLeftVelocity
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .rightToLeft)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldBegin_RightToLeft_WhenAtBottomEdge() {
        mockScrollable.mockIsAtBottom = true
        mockScrollable.mockIsAtRightEdge = true
        mockGesture.mockVelocity = .toTheLeftVelocity
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .rightToLeft)
        XCTAssert(handler.didBegin == true)
    }
    
    func testHandlePanGesture_StateChanged_ShouldNotBegin_WhenDoesntScrollHorizontally_AndIsInVerticalMiddle() {
        mockScrollable.mockIsAtRightEdge = true
        mockScrollable.mockIsAtLeftEdge = true
        mockScrollable.mockIsInVerticalMiddle = true
        
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.wasCalled == false)
        XCTAssert(handler.didBegin == false)
    }
    
    func testHandlePanGesture_StateChanged_ShouldNotBegin_WhenDoesntScrollVertically_AndIsInHorizontalMiddle() {
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtBottom = true
        mockScrollable.mockIsInHorizontalMiddle = true
        
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.beginCalled.wasCalled == false)
        XCTAssert(handler.didBegin == false)
    }
    
    func testHandlePanGesture_StateChanged_ShouldUpdate() {
        mockGesture.mockState = .changed
        
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.updateCalled.wasCalled)
    }
    
    func testHandlePanGesture_StateChanged_ShouldUpdate_SendCorrectProgress_WithoutTranslationOffset() {
        mockGesture.mockState = .changed
        mockGesture.mockTranslation = CGPoint.upwardPanVelocity
        mockGesture.mockView = view
        mockScrollable.mockIsAtBottom = true
        handler.inProgressTransitionOrientation = .bottomToTop
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockGesture.passedCorrectViewInTranslationCall)
        XCTAssert(mockHandlerDelegate.updateCalled.progress == 0.02500000037252903)
        XCTAssert(handler.shouldFinish == false)
    }
    
    func testHandlePanGesture_StateChanged_ShouldUpdate_SendCorrectProgress_WithTranslationOffset() {
        mockGesture.mockState = .changed
        mockGesture.mockTranslation = CGPoint(x: 10, y: 10)
        
        handler.handlePanGesture(mockGesture)
        
        mockGesture.mockTranslation = CGPoint(x: 10, y: 20)
        mockGesture.mockView = view
        
        handler.inProgressTransitionOrientation = .topToBottom
        handler.handlePanGesture(mockGesture)
        XCTAssert(mockGesture.passedCorrectViewInTranslationCall)
        XCTAssert(mockHandlerDelegate.updateCalled.progress == 0.02500000037252903)
        XCTAssert(handler.shouldFinish == false)
    }
}
