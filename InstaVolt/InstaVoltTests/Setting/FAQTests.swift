//
//  FAQTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 28/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class FAQTests: XCTestCase {
    
    func testCallFAQAPI()
    {
        let response = APITestUtils().getMockData(file: "contactUs")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let faqResult = try? JSONDecoder().decode(ContactUs.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(faqResult)
        XCTAssertNotNil(faqResult.data?.faqURL?.stringValue)
        if let faqURL = URL(string: faqResult.data?.faqURL?.stringValue ?? "") {
            let canOpenFAQ = UIApplication.shared.canOpenURL(faqURL)
            XCTAssertEqual(canOpenFAQ,  true)
        }
    }
}
