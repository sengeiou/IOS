//
//  LoginTests.swift
//  InstaVoltTests
//
//  Created by PCQ111 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class LoginTests: XCTestCase {
    
    func testgetAWSCognitoUser()
    {
        let response = APITestUtils().getMockData(file: "AWSLoginResponse")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let userData = try? JSONDecoder().decode(DriverData.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(userData)
        XCTAssertNotNil(userData.email?.stringValue)
        XCTAssertNotNil(userData.emailVerified?.boolValue)
        XCTAssertNotNil(userData.sub?.stringValue)
    }
    
    func testgetAWSTokenForInstaVoltLogin()
    {
        let response = APITestUtils().getMockData(file: "AWSSampleTokenResponse")
        XCTAssertNotNil(response)
        XCTAssertNotNil(response["access_token"] as? String)
        XCTAssertNotNil(response["refresh_token"] as? String)
        XCTAssertNotNil(response["id_token"] as? String)
        XCTAssertNotNil(response["token_type"] as? String)
        XCTAssertNotNil(response["expires_in"] as? Int)
    }
}
