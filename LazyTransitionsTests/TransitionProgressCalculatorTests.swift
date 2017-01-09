//
//  TransitionProgressCalculatorTests.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/2/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import XCTest
@testable import LazyTransitions

class TransitionProgressCalculatorTests: XCTestCase {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
    
    func testCalculateProgress_TopToBottomTransition_PanningDown() {
        let translation = CGPoint(x: 0, y: 10)
        
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .topToBottom)
        XCTAssert(progress == 0.02500000037252903)
    }
    
    func testCalculateProgress_TopToBottomTransition_PanningUp() {
        let translation = CGPoint(x: 0, y: -10)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                         withGestureTranslation: translation,
                                                         withTranslationOffset: .zero,
                                                         with: .topToBottom)
        XCTAssert(progress == 0)
    }
    
    func testCalculateProgress_TopToBottomTransition_PanningDown_BeyondViewBounds() {
        let translation = CGPoint(x: 0, y: 450)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .topToBottom)
        
        XCTAssert(progress == 1)
    }
    
    func testCalculateProgress_BottomToTop_PanningDown() {
        let translation = CGPoint(x: 0, y: 10)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .bottomToTop)
        XCTAssert(progress == 0)
    }
    
    func testCalculateProgress_BottomToTop_PanningUp() {
        let translation = CGPoint(x: 0, y: -10)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .bottomToTop)
        
        XCTAssert(progress == 0.02500000037252903)
    }
    
    func testCalculateProgress_BottomToTopTransition_PanningDown_BeyondViewBounds() {
        let translation = CGPoint(x: 0, y: -450)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .bottomToTop)
        
        XCTAssert(progress == 1)
    }
    
    func testCalculateProgress_LeftToRightTransition_PanningRight() {
        let translation = CGPoint(x: 10, y: 0)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .leftToRight)
        XCTAssert(progress == 0.05000000074505806)
    }
    
    func testCalculateProgress_LeftToRightTransition_PanningLeft() {
        let translation = CGPoint(x: -10, y: 0)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .leftToRight)
        
        XCTAssert(progress == 0)
    }
    
    func testCalculateProgress_LeftToRightTransition_PanningRight_BeyondViewBounds() {
        let translation = CGPoint(x: 220, y: 0)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .leftToRight)
        
        XCTAssert(progress == 1)
    }
    
    func testCalculateProgress_RightToLeftTransition_PanningRight() {
        let translation = CGPoint(x: 10, y: 0)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .rightToLeft)
        
        XCTAssert(progress == 0)
    }
    
    func testCalculateProgress_RightToLeftTransition_PanningLeft() {
        let translation = CGPoint(x: -10, y: 0)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .rightToLeft)
        
        XCTAssert(progress == 0.05000000074505806)
    }
    
    func testCalculateProgress_RightToLeftTransition_PanningLeft_BeyondViewBounds() {
        let translation = CGPoint(x: -220, y: 0)
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: .zero,
                                                          with: .rightToLeft)
        
        XCTAssert(progress == 1)
    }
    
    func testCalculateProgress_ReactingToTranslationOffset() {
        let translation = CGPoint(x: 20, y: 10)
        let translationOffset = CGPoint(x: 10, y: 10)
        
        let progress = TransitionProgressCalculator.progress(for: view,
                                                          withGestureTranslation: translation,
                                                          withTranslationOffset: translationOffset,
                                                          with: .leftToRight)
        
        XCTAssert(progress == 0.05000000074505806)
    }
}
