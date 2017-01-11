//
//  UIScrollViewExtensionsTests.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/9/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import XCTest
@testable import LazyTransitions

class UIScrollViewExtensionsTests: XCTestCase {
    var scrollView: UIScrollView!
    
    override func setUp() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        scrollView.contentSize = CGSize(width: 200, height: 300)
    }
    
    func testisAtTop_True() {
        XCTAssert(scrollView.isAtTop)
        XCTAssert(!scrollView.isAtBottom)
        XCTAssert(!scrollView.isSomeWhereInVerticalMiddle)
    }
    
    func testIsAtTop_True_WithContentInset() {
        scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -64)
        XCTAssert(scrollView.isAtTop)
        XCTAssert(!scrollView.isAtBottom)
        XCTAssert(!scrollView.isSomeWhereInVerticalMiddle)
    }
    
    func testisAtTop_False() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 10), animated: false)
        XCTAssert(!scrollView.isAtTop)
        XCTAssert(!scrollView.isAtBottom)
        XCTAssert(scrollView.isSomeWhereInVerticalMiddle)
    }
    
    func testisAtTop_False_WithContentInset() {
        scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -40)
        XCTAssert(!scrollView.isAtTop)
        XCTAssert(!scrollView.isAtBottom)
        XCTAssert(scrollView.isSomeWhereInVerticalMiddle)
    }
    
    func testisAtBottom_True_FirstScenario() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
        XCTAssert(scrollView.isAtBottom)
        XCTAssert(!scrollView.isAtTop)
        XCTAssert(!scrollView.isSomeWhereInVerticalMiddle)
    }
    
    func testisAtBottom_True_SecondScenario() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: false)
        XCTAssert(scrollView.isAtBottom)
        XCTAssert(!scrollView.isAtTop)
        XCTAssert(!scrollView.isSomeWhereInVerticalMiddle)
    }
    
    func testisAtLeftEdge_True() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        XCTAssert(scrollView.isAtLeftEdge)
        XCTAssert(!scrollView.isAtRightEdge)
        XCTAssert(!scrollView.isSomeWhereInHorizontalMiddle)
    }
    
    func testisAtLeftEdge_True_WithContentInset() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        scrollView.setContentOffset(CGPoint(x: -10, y: 0), animated: false)
        
        XCTAssert(scrollView.isAtLeftEdge)
        XCTAssert(!scrollView.isAtRightEdge)
        XCTAssert(!scrollView.isSomeWhereInHorizontalMiddle)
    }
    
    func testisAtLeftEdge_False() {
        scrollView.setContentOffset(CGPoint(x: 10, y: 0), animated: false)
        XCTAssertFalse(scrollView.isAtLeftEdge)
        XCTAssertFalse(scrollView.isAtRightEdge)
        XCTAssert(scrollView.isSomeWhereInHorizontalMiddle)
    }
    
    func testisAtRightEdge_True_FirstScenario() {
        scrollView.setContentOffset(CGPoint(x: 100, y: 10), animated: false)
        XCTAssert(scrollView.isAtRightEdge)
        XCTAssertFalse(scrollView.isAtLeftEdge)
        XCTAssertFalse(scrollView.isSomeWhereInHorizontalMiddle)
    }
    
    func testisAtRightEdge_True_SecondScenario() {
        scrollView.setContentOffset(CGPoint(x: 120, y: 10), animated: false)
        XCTAssert(scrollView.isAtRightEdge)
        XCTAssertFalse(scrollView.isAtLeftEdge)
        XCTAssertFalse(scrollView.isSomeWhereInHorizontalMiddle)
    }
}
