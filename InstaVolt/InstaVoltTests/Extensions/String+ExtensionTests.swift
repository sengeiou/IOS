//
//  String+ExtensionTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class String_ExtensionTests: XCTestCase {
    
    func testValidPassword()
    {
        XCTAssertTrue("12345678".isValidPassword)
        XCTAssertFalse("123".isValidPassword)
        XCTAssertFalse("123456789012345678".isValidPassword)
    }
    
    func testValidaEmail()
    {
        XCTAssertTrue("test123@gmail.com".isValidEmail)
        XCTAssertFalse("test@gmail".isValidEmail)
        XCTAssertFalse("test".isValidEmail)
    }
    
    func testValidName()
    {
        XCTAssertTrue("TestName".isValidName)
        XCTAssertFalse("Test1233".isValidName)
        XCTAssertFalse("TestTestTestTest".isValidName)
    }
    
    func textValidCVV()
    {
        XCTAssertTrue("123".isValidCvv)
        XCTAssertFalse("a12".isValidCvv)
        XCTAssertFalse("12345".isValidCvv)
        XCTAssertTrue("1234".isValidCvv)
    }
    
    func testLength()
    {
        XCTAssertEqual("Test".length, 4)
        XCTAssertNotEqual("Test".length, 5)
    }
    
    func testTrimmedLength()
    {
        XCTAssertNotNil("  Test   ".trimmedLength)
        XCTAssertEqual("  Test  ".trimmedLength, 4)
        XCTAssertEqual("   ".trimmedLength, 0)
    }
    
    func testIsEqualToString()
    {
        XCTAssertTrue("Test".isEqualToString(find: "Test"))
        XCTAssertFalse("Test".isEqualToString(find: "ee"))
    }
    
    func testIsInt()
    {
        XCTAssertTrue("4".isInt)
        XCTAssertFalse("A".isInt)
    }
    
    func testNumberValue()
    {
        XCTAssertEqual("123".numberValue, 123)
        XCTAssertNil("abc".numberValue)
        XCTAssertNotEqual("123a".numberValue, 123)
    }
    
    func testBoolValue()
    {
        XCTAssertEqual("true".toBool(), true)
        XCTAssertEqual("True".toBool(), true)
        XCTAssertEqual("yes".toBool(), true)
        XCTAssertEqual("1".toBool(), true)
        XCTAssertFalse("Test".toBool() ?? true)
        XCTAssertEqual("False".toBool(), false)
        XCTAssertEqual("false".toBool(), false)
        XCTAssertEqual("no".toBool(), false)
        XCTAssertEqual("0".toBool(), false)
    }
    
    func testStingToDate()
    {
        let date = "03-25-2021".stringToDate
        XCTAssertNotNil(date)
        XCTAssert((date as Any) is Date)
    }
    
    func testStringToDateWithMiliSecond()
    {
        let date = "2019-03-16T00:09:46.73".stringToDateWithMiliSecond
        XCTAssertNotNil(date)
        XCTAssert((date as Any) is Date)
    }
    
    func textTrim()
    {
        XCTAssertNotNil("  test \n test  ".trimmed)
        XCTAssertEqual("  test  \n test".trimmed, "testtest")
        XCTAssertEqual("   ".trimmed, "")
    }
    
    func testCheckIfNil()
    {
        XCTAssertEqual("   ".trim().checkIfNil,"N/A")
    }
    
    func testDoubleFormatter()
    {
        XCTAssertEqual("23.0".toDouble(), 23.00)
        XCTAssertEqual("23".toDouble(), 23.0)
        XCTAssertNil("abc23".toDouble())
    }
    
}
