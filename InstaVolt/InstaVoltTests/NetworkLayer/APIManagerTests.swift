//
//  APIManagerTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 03/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class APIManagerTests: XCTestCase {

    func testSendRequest()
    {
        APIManager.API.sendRequest(.getDriverData, type: TempDriverResponse.self
            , successCompletion: { (response) in
                if response.data == nil
                {
                    XCTFail()
                }
                XCTAssertNotNil(response)
                XCTAssertNotNil(response.data)
        }) { (error, ErrorResponse) in
            if error.errorMessage == nil
            {
                    XCTFail()
            }
        }
    }

}
