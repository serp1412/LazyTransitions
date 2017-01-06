//
//  DefaultInteractiveTransitionerTests.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/8/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import XCTest
@testable import LazyTransitions

struct BeginWithTransitionerCalled {
    private(set) var wasCalled: Bool = false
    var transitioner: Transitioner
    
    init(transitioner: Transitioner) {
        self.transitioner = transitioner
        wasCalled = true
    }
}

struct FinishWithCompletionCalled {
    private(set) var wasCalled: Bool = false
    var completed: Bool = false
    
    init(completed: Bool) {
        self.completed = completed
        wasCalled = true
    }
}

class MockTransitionerDelegate: TransitionerDelegate {
    var beginCalled: BeginWithTransitionerCalled!
    var finishCalled: FinishWithCompletionCalled!
    
    func beginTransition(with transitioner: Transitioner) {
        beginCalled = BeginWithTransitionerCalled(transitioner: transitioner)
    }
    
    func finishedInteractiveTransition(_ completed: Bool) {
        finishCalled = FinishWithCompletionCalled(completed: completed)
    }
}

class MockTransitionAnimator: NSObject, TransitionAnimator {
    var delegate: TransitionAnimatorDelegate?
    var orientation: TransitionOrientation
    var allowedOrientations: [TransitionOrientation]?
    
    var supportedOrientations: [TransitionOrientation] = [.leftToRight, .rightToLeft, .topToBottom, .bottomToTop]
    
    required init(orientation: TransitionOrientation) {
        self.orientation = orientation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { return 0 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
}

class MockTransitionInteractor: TransitionInteractor {
    var completionSpeedForCancelCalled = false
    var completionSpeedForFinishCalled = false
    var finishCalled = false
    var cancelCalled = false
    
    var updateCalled = UpdateWithProgressCalled()
    
    override func setCompletionSpeedForCancel() {
        completionSpeedForCancelCalled = true
    }
    
    override func setCompletionSpeedForFinish() {
        completionSpeedForFinishCalled = true
    }
    
    override func update(_ percentComplete: CGFloat) {
        updateCalled.progress = Float(percentComplete)
    }
    
    override func finish() {
        finishCalled = true
    }
    
    override func cancel() {
        cancelCalled = true
    }
}

class DefaultInteractiveTransitionerTests: XCTestCase {
    
    var mockAnimator: MockTransitionAnimator!
    var mockHandler: MockGestureHandler!
    var mockDelegate: MockTransitionerDelegate!
    var transitioner: DefaultInteractiveTransitioner!
    var mockInteractor: MockTransitionInteractor!
    
    override func setUp() {
        mockInteractor = MockTransitionInteractor()
        mockHandler = MockGestureHandler()
        mockAnimator = MockTransitionAnimator(orientation: .leftToRight)
        mockDelegate = MockTransitionerDelegate()
        transitioner = DefaultInteractiveTransitioner(with: mockHandler, with: mockAnimator, with: mockInteractor)
        transitioner.delegate = mockDelegate
    }
    
    func testDelegateAssignment() {
        guard let handlerDelegate = mockHandler.delegate else {
            XCTFail("handlerDelegate should not be nil")
            return
        }
        XCTAssert(handlerDelegate === transitioner)
        
        guard let animatorDelegate = mockAnimator.delegate else {
            XCTFail("animatorDelegate should not be nil")
            return
        }
        
        XCTAssert(animatorDelegate === transitioner)
    }
    
    func testBeginInteractiveTransition() {
        transitioner.beginInteractiveTransition(with: .leftToRight)
        
        XCTAssert(mockAnimator.orientation == .leftToRight)
        XCTAssert(mockDelegate.beginCalled.transitioner === transitioner)
    }
    
    func testBeginInteractiveTransition_UnsupportedOrientation() {
        mockAnimator.supportedOrientations = [.leftToRight, .rightToLeft]
        
        transitioner = DefaultInteractiveTransitioner(with: mockHandler, with: mockAnimator, with: mockInteractor)
        transitioner.delegate = mockDelegate
        
        transitioner.beginInteractiveTransition(with: .topToBottom)
        
        XCTAssertNil(mockDelegate.beginCalled)
    }
    
    func testBeginInteractiveTransition_DissallowedOrientation() {
        mockAnimator.supportedOrientations = [.leftToRight, .rightToLeft]
        mockAnimator.allowedOrientations = [.bottomToTop]
        
        transitioner = DefaultInteractiveTransitioner(with: mockHandler, with: mockAnimator, with: mockInteractor)
        transitioner.delegate = mockDelegate
        
        transitioner.beginInteractiveTransition(with: .leftToRight)
        
        XCTAssertNil(mockDelegate.beginCalled)
    }
    
    func testBeginInteractiveTransition_AllowedOrientationsIsNil() {
        mockAnimator.supportedOrientations = [.leftToRight, .rightToLeft]
        
        transitioner = DefaultInteractiveTransitioner(with: mockHandler, with: mockAnimator, with: mockInteractor)
        transitioner.delegate = mockDelegate
        
        transitioner.beginInteractiveTransition(with: .leftToRight)
        
        XCTAssert(mockDelegate.beginCalled.wasCalled)
    }
    
    func testUpdateInteractiveTransition() {
        let progress: Float = 0.5
        transitioner.updateInteractiveTransitionWithProgress(progress)
        
        XCTAssert(mockInteractor.updateCalled.progress == progress)
    }
    
    func testFinishInteractiveTransition() {
        transitioner.finishInteractiveTransition()
        
        XCTAssert(mockInteractor.completionSpeedForFinishCalled)
        XCTAssert(mockInteractor.finishCalled)
    }
    
    func testCancelInteractiveTransition() {
        transitioner.cancelInteractiveTransition()
        
        XCTAssert(mockInteractor.completionSpeedForCancelCalled)
        XCTAssert(mockInteractor.cancelCalled)
    }
    
    func testTransitionDidFinish_Completed() {
        transitioner.transitionDidFinish(true)
        
        XCTAssert(mockDelegate.finishCalled.completed == true)
    }
    
    func testTransitionDidFinish_Cancelled() {
        transitioner.transitionDidFinish(false)
        
        XCTAssert(mockDelegate.finishCalled.completed == false)
    }
}
