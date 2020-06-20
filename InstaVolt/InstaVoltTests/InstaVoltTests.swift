//
//  InstaVoltTests.swift
//  InstaVoltTests
//
//  Created by PCQ111 on 08/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class InstaVoltTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
//    func testAPIWorking()
//    {
//
//        let expectation = XCTestExpectation.init(description: "driver")
//         
//        DriverController.shared.getDriverDetails(successCompletion: { (driver) in
//            print(driver.firstName?.stringValue ?? "")
//            
//            expectation.fulfill()
//            
//        }) { (error, resError) in
//            XCTFail("Fail")
//        }
//            
//           
//        // We ask the unit test to wait our expectation to finish.
//        self.waitForExpectations(timeout: 20)
//    }

}
