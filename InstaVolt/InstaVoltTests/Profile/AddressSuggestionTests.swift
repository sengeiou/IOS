//
//  AddressSuggestionTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class AddressSuggestionTests: XCTestCase {

    func testCallGetAddressAPI()
    {
        let response = APITestUtils().getMockData(file: "AddressSuggestion")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let addressSuggestion = try? JSONDecoder().decode(AddressSuggestion.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(addressSuggestion)
        XCTAssertNotNil(addressSuggestion.latitude?.doubleValue)
        XCTAssertNotNil(addressSuggestion.longitude?.doubleValue)
        XCTAssertNotEqual(addressSuggestion.addresses?.count, 0)
        XCTAssertNotNil(addressSuggestion.addresses?[0].stringValue)
    }
   

}
