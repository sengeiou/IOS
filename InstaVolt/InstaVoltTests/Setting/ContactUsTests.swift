//
//  ContactUsTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class ContactUsTests: XCTestCase {

    func testContactUSAPI()
    {
        let response = APITestUtils().getMockData(file: "contactUs")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let contactUs = try? JSONDecoder().decode(ContactUs.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(contactUs)
        XCTAssertNotNil(contactUs.message?.stringValue)
        XCTAssertNotNil(contactUs.data?.phone?.stringValue)
        XCTAssertNotNil(contactUs.data?.email?.stringValue)
        XCTAssertNotNil(contactUs.data?.address?.stringValue)
    }
}
