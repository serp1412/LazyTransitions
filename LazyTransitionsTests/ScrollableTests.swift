//
//  ScrollableTests.swift
//  Wadi
//
//  Created by Serghei Catraniuc on 1/4/17.
//  Copyright © 2017 YOPESO. All rights reserved.
//

import XCTest
@testable import LazyTransitions

class ScrollableTests : XCTestCase {
    var mockScrollable: MockScrollable!
    
    override func setUp() {
        mockScrollable = MockScrollable()
    }
    
    func testPossibleVerticalOrientation_TopToBottom() {
        mockScrollable.mockIsAtTop = true
        
        XCTAssertEqual(mockScrollable.possibleVerticalOrientation, .topToBottom)
    }
    
    func testPossibleVerticalOrientation_BottomToTop() {
        mockScrollable.mockIsAtBottom = true
        
        XCTAssertEqual(mockScrollable.possibleVerticalOrientation, .bottomToTop)
    }
    
    func testPossibleHorizontalOrientation_LeftToRight() {
        mockScrollable.mockIsAtLeftEdge = true
        
        XCTAssertEqual(mockScrollable.possibleHorizontalOrientation, .leftToRight)
    }
    
    func testPossibleHorizontalOrientation_RightToLeft() {
        mockScrollable.mockIsAtRightEdge = true
        
        XCTAssertEqual(mockScrollable.possibleHorizontalOrientation, .rightToLeft)
    }
    
    func testScrollsHorizontally_False() {
        mockScrollable.mockIsAtLeftEdge = true
        mockScrollable.mockIsAtRightEdge = true
        
        XCTAssertFalse(mockScrollable.scrollsHorizontally)
    }
    
    func testScrollsHorizontally_True_FirstScenario() {
        mockScrollable.mockIsAtLeftEdge = false
        mockScrollable.mockIsAtRightEdge = true
        
        XCTAssert(mockScrollable.scrollsHorizontally)
    }
    
    func testScrollsHorizontally_True_SecondScenario() {
        mockScrollable.mockIsAtLeftEdge = false
        mockScrollable.mockIsAtRightEdge = false
        
        XCTAssert(mockScrollable.scrollsHorizontally)
    }
    
    func testScrollsVertically_False() {
        mockScrollable.mockIsAtTop = true
        mockScrollable.mockIsAtBottom = true
        
        XCTAssertFalse(mockScrollable.scrollsVertically)
    }
    
    func testScrollsVertically_True_FirstScenario() {
        mockScrollable.mockIsAtTop = false
        mockScrollable.mockIsAtBottom = true
        
        XCTAssert(mockScrollable.scrollsVertically)
    }
    
    func testScrollsVertically_True_SecondScenario() {
        mockScrollable.mockIsAtTop = false
        mockScrollable.mockIsAtBottom = false
        
        XCTAssert(mockScrollable.scrollsVertically)
    }
}
