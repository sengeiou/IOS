//
//  ProfileTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class ProfileTests: XCTestCase {
    
    func testDriverDetailAPI()
    {
        let response = APITestUtils().getMockData(file: "DriverProfile")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let driverDetail = try? JSONDecoder().decode(DriverResponse.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(driverDetail)
        XCTAssertNotNil(driverDetail.message?.stringValue)
        XCTAssertNotNil(driverDetail.data?.first_name?.stringValue)
        XCTAssertNotNil(driverDetail.data?.last_name?.stringValue)
        XCTAssertNotNil(driverDetail.data?.email?.stringValue)
        XCTAssertNotNil(driverDetail.data?.status?.id?.intValue)
        XCTAssertNotNil(driverDetail.data?.status?.name?.stringValue)
        XCTAssertNotNil(driverDetail.data?.status?.code?.stringValue)
        XCTAssertNotNil(driverDetail.data?.address?.stringValue)
        XCTAssertNotNil(driverDetail.data?.billing_address?.stringValue)
        XCTAssertEqual(driverDetail.data?.is_profile_verified?.boolValue, true)
        XCTAssertNotEqual(driverDetail.data?.email?.stringValue, "")
    }
    
    func testUpdateDriverAPI()
    {
        let response = APITestUtils().getMockData(file: "UpdateDriverProfile")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let updatedDriverData = try? JSONDecoder().decode(SuccessMessage.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(updatedDriverData)
        XCTAssertNotEqual(updatedDriverData.message?.stringValue, "")
    }
    
    func testCancelAccountAPI()
    {
        let response = APITestUtils().getMockData(file: "CancelAccount")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let cancelAccountResponse = try? JSONDecoder().decode(SuccessMessage.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(cancelAccountResponse)
        XCTAssertNotEqual(cancelAccountResponse.message?.stringValue, "")
    }
    
}
