//
//  ChangePasswordTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class ChangePasswordTests: XCTestCase {

    func testChangePasswordAPI()
    {
        let response = APITestUtils().getMockData(file: "ChangePassword")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let changePasswordResponse = try? JSONDecoder().decode(SuccessMessage.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(changePasswordResponse)
        XCTAssertNotNil(changePasswordResponse.message)
        XCTAssertNotEqual(changePasswordResponse.message, "")
    }
}
