//
//  RegisterTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class RegisterTests: XCTestCase {

    func testawsSignUpAPICall()
    {
        let response = APITestUtils().getMockData(file: "AWSSignUpResponse")
        XCTAssertNotNil(response["CodeDeliveryDetails"])
        guard  let codeDeliveryDetails = response["CodeDeliveryDetails"] as? [String: Any] else {
            XCTFail()
            return
        }
        XCTAssertNotNil(codeDeliveryDetails["Destination"])
        XCTAssertNotNil(codeDeliveryDetails["DeliveryMedium"] as? String)
        XCTAssertEqual(codeDeliveryDetails["DeliveryMedium"] as? String, "EMAIL")
        XCTAssertNotNil(codeDeliveryDetails["AttributeName"] as? String)
        XCTAssertNotNil(response["UserConfirmed"] as? Bool)
        XCTAssertNotNil(response["UserSub"] as? String)
    }
    
    func testSignUp()
    {
        let response = APITestUtils().getMockData(file: "SignUp")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let successSignUpMessage = try? JSONDecoder().decode(SuccessMessage.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(successSignUpMessage)
        XCTAssertNotNil(successSignUpMessage.message?.stringValue)
    }
}
