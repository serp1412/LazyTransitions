//
//  StaticViewTransitionGestureHandlerTests.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 12/7/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import XCTest
@testable import LazyTransitions

class StaticViewTransitionGestureHandlerTests: XCTestCase {
    let mockGesture = MockPanGestureRecognizer()
    var handler = StaticViewTransitionGestureHandler()
    let mockHandlerDelegate = MockGestureHandlerDelegate()
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
    
    override func setUp() {
        mockGesture.mockState = .possible
        mockGesture.mockVelocity = .zero
        mockGesture.mockView = UIView()
        mockGesture.mockTranslation = .zero
        
        mockHandlerDelegate.beginCalled = BeginWithOrientationCalled()
        mockHandlerDelegate.updateCalled = UpdateWithProgressCalled()
        mockHandlerDelegate.finishCalled = false
        mockHandlerDelegate.cancelCalled = false
        
        handler.delegate = mockHandlerDelegate
        handler.shouldFinish = false
        handler.inProgressTransitionOrientation = .unknown
    }
    
    func testHandlePanGesture_StateBegan_TopToBottomTransition() {
        mockGesture.mockState = .began
        mockGesture.mockVelocity = CGPoint.downwardPanVelocity
        handler.handlePanGesture(mockGesture)
        XCTAssert(handler.didBegin == true)
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .topToBottom)
    }
    
    func testHandlePanGesture_StateBegan_BottomToTopTransition() {
        mockGesture.mockState = .began
        mockGesture.mockVelocity = CGPoint.upwardPanVelocity
        handler.handlePanGesture(mockGesture)
        XCTAssert(handler.didBegin == true)
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .bottomToTop)
    }
    
    func testHandlePanGesture_StateBegan_LeftToRight() {
        mockGesture.mockState = .began
        mockGesture.mockVelocity = CGPoint.toTheRightVelocity
        handler.handlePanGesture(mockGesture)
        XCTAssert(handler.didBegin == true)
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .leftToRight)
    }
    
    func testHandlePanGesture_StateBegan_RightToLeft() {
        mockGesture.mockState = .began
        mockGesture.mockVelocity = CGPoint.toTheLeftVelocity
        handler.handlePanGesture(mockGesture)
        XCTAssert(handler.didBegin == true)
        XCTAssert(mockHandlerDelegate.beginCalled.orientation == .rightToLeft)
    }
    
    func testHandlePanGesture_StateChanged_BottomToTopTransition_ShouldNotFinish() {
        mockGesture.mockState = .changed
        mockGesture.mockTranslation = CGPoint.upwardPanVelocity
        mockGesture.mockView = view
        handler.inProgressTransitionOrientation = .bottomToTop
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockGesture.passedCorrectViewInTranslationCall)
        XCTAssert(mockHandlerDelegate.updateCalled.progress == 0.02500000037252903)
        XCTAssert(handler.shouldFinish == false)
    }
    
    func testHandlePanGesture_StateChanged_BottomToTopTransition_ShouldFinish() {
        mockGesture.mockState = .changed
        mockGesture.mockTranslation = CGPoint.translationThatWillTriggerTransition
        mockGesture.mockView = view
        handler.inProgressTransitionOrientation = .bottomToTop
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockGesture.passedCorrectViewInTranslationCall)
        XCTAssert(mockHandlerDelegate.updateCalled.progress == 0.5)
        XCTAssert(handler.shouldFinish == true)
    }
}
