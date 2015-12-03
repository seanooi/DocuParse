//
//  UIColorTests.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/26/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import XCTest
@testable import DocuParse

class UIColorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEqualColorWithHex() {
        let hex = "#ff0000"
        let alpha: CGFloat = 1
        let color = UIColor.colorWithHex(hex, alpha: alpha)
        
        XCTAssertEqual(color, UIColor.redColor(), "Color from hex does not match system color")
    }
    
    func testEqualColorWithoutHex() {
        let hex = "ff0000"
        let alpha: CGFloat = 1
        let color = UIColor.colorWithHex(hex, alpha: alpha)
        
        XCTAssertEqual(color, UIColor.redColor(), "Color from hex does not match system color")
    }
    
    func testDefaultColorWithHashHex() {
        let hex = "#abcd1234"
        let alpha: CGFloat = 1
        let color = UIColor.colorWithHex(hex, alpha: alpha)
        
        XCTAssertEqual(color, UIColor.blackColor(), "Default color is not black")
    }
    
    func testDefaultColorWithoutHashHex() {
        let hex = "abcd1234"
        let alpha: CGFloat = 1
        let color = UIColor.colorWithHex(hex, alpha: alpha)
        
        XCTAssertEqual(color, UIColor.blackColor(), "Default color is not black")
    }
    
    func testDefaultColorWithEmptytHex() {
        let hex = ""
        let alpha: CGFloat = 1
        let color = UIColor.colorWithHex(hex, alpha: alpha)
        
        XCTAssertEqual(color, UIColor.blackColor(), "Default color is not black")
    }

}
