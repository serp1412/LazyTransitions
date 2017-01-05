//
//  TransitionCombinatorTests.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 12/12/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import XCTest
@testable import LazyTransitions

class MockTransitioner: Transitioner {
    weak var delegate: TransitionerDelegate?
    var animator: TransitionAnimator = MockTransitionAnimator(orientation: .unknown)
    var interactor: TransitionInteractor?
}

class TransitionCombinatorTests: XCTestCase {
    var mockDelegate: MockTransitionerDelegate!
    var transitionCombinator: TransitionCombinator!
    var mockFirstTransitioner: MockTransitioner!
    var mockSecondTransitioner: MockTransitioner!
    var mockDefaultAnimator: MockTransitionAnimator!
    
    override func setUp() {
        mockDelegate = MockTransitionerDelegate()
        mockFirstTransitioner = MockTransitioner()
        mockSecondTransitioner = MockTransitioner()
        mockDefaultAnimator = MockTransitionAnimator(orientation: .unknown)
        transitionCombinator = TransitionCombinator(defaultAnimator: mockDefaultAnimator, transitioners: mockFirstTransitioner, mockSecondTransitioner)
        transitionCombinator.delegate = mockDelegate
    }
    
    func testInit() {
        XCTAssert(mockFirstTransitioner.delegate === transitionCombinator)
        XCTAssert(mockSecondTransitioner.delegate === transitionCombinator)
        XCTAssert(transitionCombinator.animator === mockDefaultAnimator)
        XCTAssert(transitionCombinator.interactor === nil)
    }
    
    func testBeginTransition_FirstTransitioner() {
        transitionCombinator.beginTransition(with: mockFirstTransitioner)
        
        XCTAssert(mockDelegate.beginCalled.transitioner === mockFirstTransitioner)
        XCTAssert(transitionCombinator.animator === mockFirstTransitioner.animator)
        XCTAssert(transitionCombinator.interactor === mockFirstTransitioner.interactor)
    }
    
    func testBeginTransition_SecondTransitioner() {
        transitionCombinator.beginTransition(with: mockSecondTransitioner)
        
        XCTAssert(mockDelegate.beginCalled.transitioner === mockSecondTransitioner)
        XCTAssert(transitionCombinator.animator === mockSecondTransitioner.animator)
        XCTAssert(transitionCombinator.interactor === mockSecondTransitioner.interactor)
    }
    
    func testFinishedTransition_Completed_True() {
        transitionCombinator.finishedInteractiveTransition(true)
        
        XCTAssert(mockDelegate.finishCalled.completed == true)
        XCTAssert(transitionCombinator.animator === mockDefaultAnimator)
        XCTAssert(transitionCombinator.interactor === nil)
    }
    
    func testFinishedTransition_Completed_False() {
        transitionCombinator.finishedInteractiveTransition(false)
        
        XCTAssert(mockDelegate.finishCalled.completed == false)
        XCTAssert(transitionCombinator.animator === mockDefaultAnimator)
        XCTAssert(transitionCombinator.interactor === nil)
    }
    
    func testAddTransitioner() {
        let newTransitioner = MockTransitioner()
        let count = transitionCombinator.transitioners.count
        
        transitionCombinator.add(newTransitioner)
        
        XCTAssert(newTransitioner.delegate === transitionCombinator)
        XCTAssert(transitionCombinator.transitioners.count - count == 1)
    }
    
    func testRemoveTransitioner_DoesntExist() {
        let newTransitioner = MockTransitioner()
        
        let count = transitionCombinator.transitioners.count
        
        transitionCombinator.remove(newTransitioner)
        
        XCTAssert(count == transitionCombinator.transitioners.count)
    }
    
    func testRemoveTransitioner_DoesExist_NoNeedForDelay() {
        let newTransitioner = MockTransitioner()
        
        transitionCombinator.add(newTransitioner)
        
        let count = transitionCombinator.transitioners.count
        
        transitionCombinator.remove(newTransitioner)
        
        XCTAssert(count - transitionCombinator.transitioners.count == 1)
        XCTAssert(!transitionCombinator.transitioners.contains(where: { $0 === newTransitioner }))
    }
    
    func testRemoveTransitioner_DoesExist_NeedsDelay() {
        let newTransitioner = MockTransitioner()
        
        transitionCombinator.add(newTransitioner)
        
        let count = transitionCombinator.transitioners.count
        
        transitionCombinator.beginTransition(with: mockFirstTransitioner)
        
        transitionCombinator.remove(newTransitioner)
        
        XCTAssert(count == transitionCombinator.transitioners.count)
        XCTAssert(transitionCombinator.transitioners.contains(where: { $0 === newTransitioner }))
        
        transitionCombinator.finishedInteractiveTransition(true)
        
        XCTAssert(count - transitionCombinator.transitioners.count == 1)
        XCTAssert(!transitionCombinator.transitioners.contains(where: { $0 === newTransitioner }))
    }
    
    func testAllowedOrientations_ShouldNotApplyWhenNil() {
        let initialOrientations: [TransitionOrientation] = [.leftToRight]
        mockFirstTransitioner.animator.allowedOrientations = initialOrientations
        transitionCombinator = TransitionCombinator(transitioners: mockFirstTransitioner)
        
        XCTAssert(initialOrientations == mockFirstTransitioner.animator.allowedOrientations!)
        
        let newTransitioner = MockTransitioner()
        newTransitioner.animator.allowedOrientations = initialOrientations
        
        transitionCombinator.add(newTransitioner)
        
        XCTAssert(initialOrientations == newTransitioner.animator.allowedOrientations!)
    }
    
    func testAllowedOrientations_ShouldApply() {
        let orientations: [TransitionOrientation] = [.leftToRight]
        mockFirstTransitioner.animator.allowedOrientations = orientations
        transitionCombinator = TransitionCombinator(transitioners: mockFirstTransitioner)
        let allowedOrientations: [TransitionOrientation] = [.bottomToTop]
        transitionCombinator.allowedOrientations = allowedOrientations
        
        XCTAssert(allowedOrientations == mockFirstTransitioner.animator.allowedOrientations!)
        
        let newTransitioner = MockTransitioner()
        newTransitioner.animator.allowedOrientations = orientations
        
        transitionCombinator.add(newTransitioner)
        
        XCTAssert(allowedOrientations == newTransitioner.animator.allowedOrientations!)
    }
}
