//
//  TransitionGestureHandlerTests.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/8/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import XCTest
@testable import LazyTransitions

class MockPanGestureRecognizer: UIPanGestureRecognizer {
    var mockState: UIGestureRecognizerState = .possible
    var mockVelocity: CGPoint = .zero
    var mockTranslation: CGPoint = .zero
    var mockView: UIView = UIView()
    
    var passedCorrectViewInTranslationCall: Bool = false
    
    override var state: UIGestureRecognizerState {
        get { return mockState }
    }
    
    override func velocity(in view: UIView?) -> CGPoint {
        return mockVelocity
    }
    
    override func translation(in view: UIView?) -> CGPoint {
        if let view = view {
            passedCorrectViewInTranslationCall = view.isEqual(mockView)
        }
        return mockTranslation
    }
    
    override var view: UIView? {
        get { return mockView }
    }
}

struct BeginWithOrientationCalled {
    private(set) var wasCalled: Bool = false
    var orientation: TransitionOrientation = .unknown {
        didSet {
            wasCalled = true
        }
    }
}

struct UpdateWithProgressCalled {
    private(set) var wasCalled: Bool = false
    var progress: Float = 0 {
        didSet {
            wasCalled = true
        }
    }
}

class MockGestureHandlerDelegate: TransitionGestureHandlerDelegate {
    
    var beginCalled: BeginWithOrientationCalled = BeginWithOrientationCalled()
    var updateCalled: UpdateWithProgressCalled = UpdateWithProgressCalled()
    var finishCalled: Bool = false
    var cancelCalled: Bool = false
    
    func beginInteractiveTransition(with orientation: TransitionOrientation) {
        beginCalled = BeginWithOrientationCalled()
        beginCalled.orientation = orientation
    }
    
    func updateInteractiveTransitionWithProgress(_ progress: Float) {
        updateCalled = UpdateWithProgressCalled()
        updateCalled.progress = progress
    }
    
    func finishInteractiveTransition() {
        finishCalled = true
    }
    
    func cancelInteractiveTransition() {
        cancelCalled = true
    }
}

extension CGPoint {
    static var downwardPanVelocity: CGPoint {
        return CGPoint(x: 0, y: 10)
    }
    
    static var upwardPanVelocity: CGPoint {
        return CGPoint(x: 0, y: -10)
    }
    
    static var toTheRightVelocity: CGPoint {
        return CGPoint(x: 10, y: 0)
    }
    
    static var toTheLeftVelocity: CGPoint {
        return CGPoint(x: -10, y: 0)
    }
    
    static var velocityThatWillTriggerQuickSwipeTransition: CGPoint {
        return CGPoint(x: 0, y: 1200)
    }
    
    static var velocityThatWontTriggerQuickSwipeTransition: CGPoint {
        return CGPoint(x: 0, y: 900)
    }
    
    static var translationThatWillTriggerTransition: CGPoint {
        return CGPoint(x: 0, y: -200)
    }
}

class MockGestureHandler: TransitionGestureHandler {
    var delegate: TransitionGestureHandlerDelegate? = nil
    var shouldFinish: Bool = false
    var didBegin: Bool = false
    var inProgressTransitionOrientation: TransitionOrientation = .unknown
    
    func didChange(_ gesture: UIPanGestureRecognizer) { }
    
    func calculateTransitionProgressWithTranslation(_ translation: CGPoint, on view: UIView?) -> Float { return 0 }
}

class TransitionGestureHandlerTests: XCTestCase {
    let mockGesture = MockPanGestureRecognizer()
    var handler = MockGestureHandler()
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
    
    func testHandlePanGesture_StateEnded_ShouldFinish_True() {
        mockGesture.mockState = .ended
        handler.shouldFinish = true
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.finishCalled)
        XCTAssert(handler.didBegin == false)
    }
    
    func testHandlePanGesture_StateEnded_ShouldFinish_False() {
        mockGesture.mockState = .ended
        handler.shouldFinish = false
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.cancelCalled)
        XCTAssert(handler.didBegin == false)
    }
    
    func testHandlePanGesture_StateEnded_QuickSwipeTransition_True() {
        mockGesture.mockState = .ended
        mockGesture.mockVelocity = CGPoint.velocityThatWillTriggerQuickSwipeTransition
        handler.inProgressTransitionOrientation = .topToBottom
        handler.didBegin = true
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.finishCalled)
        XCTAssert(handler.didBegin == false)
    }
    
    func testHandlePanGesture_StateEnded_QuickSwipeTransition_False() {
        mockGesture.mockState = .ended
        mockGesture.mockVelocity = CGPoint.velocityThatWontTriggerQuickSwipeTransition
        handler.inProgressTransitionOrientation = .topToBottom
        handler.didBegin = true
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.cancelCalled)
        XCTAssert(handler.didBegin == false)
    }
    
    func testHandlePanGesture_StateCanceled() {
        mockGesture.mockState = .cancelled
        handler.handlePanGesture(mockGesture)
        
        XCTAssert(mockHandlerDelegate.cancelCalled)
    }
}
