//
//  ForgotPasswordTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class ForgotPasswordTests: XCTestCase {

    func testAwsForgotPasswordAPI()
    {
        let response = APITestUtils().getMockData(file: "ForgotPassword")
        XCTAssertNotNil(response["CodeDeliveryDetails"])
        guard  let codeDeliveryDetails = response["CodeDeliveryDetails"] as? [String: Any] else {
            XCTFail()
            return
        }
        XCTAssertNotNil(codeDeliveryDetails["Destination"])
        XCTAssertNotNil(codeDeliveryDetails["DeliveryMedium"] as? String)
        XCTAssertEqual(codeDeliveryDetails["DeliveryMedium"] as? String, "EMAIL")
        XCTAssertNotNil(codeDeliveryDetails["AttributeName"] as? String)
    }

}
