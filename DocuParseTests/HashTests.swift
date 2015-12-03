//
//  HashTests.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/28/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import XCTest
@testable import DocuParse

class HashTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMD5() {
        XCTAssertEqual("123".md5(), "202cb962ac59075b964b07152d234b70", "MD5 calculation failed")
        XCTAssertEqual("".md5(), "d41d8cd98f00b204e9800998ecf8427e", "MD5 calculation failed")
        XCTAssertEqual("a".md5(), "0cc175b9c0f1b6a831c399e269772661", "MD5 calculation failed")
        XCTAssertEqual("abc".md5(), "900150983cd24fb0d6963f7d28e17f72", "MD5 calculation failed")
        XCTAssertEqual("message digest".md5(), "f96b697d7cb7938d525a2f31aaf161d0", "MD5 calculation failed")
        XCTAssertEqual("abcdefghijklmnopqrstuvwxyz".md5(), "c3fcd3d76192e4007dfb496cca67e13b", "MD5 calculation failed")
        XCTAssertEqual("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".md5(), "d174ab98d277d9f5a5611c2c9f419d9f", "MD5 calculation failed")
        XCTAssertEqual("12345678901234567890123456789012345678901234567890123456789012345678901234567890".md5(), "57edf4a22be3c955ac49da2e2107b67a", "MD5 calculation failed")
    }

}
