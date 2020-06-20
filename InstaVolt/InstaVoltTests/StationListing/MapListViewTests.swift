//
//  MapListViewTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 12/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class MapListViewTests: XCTestCase {

    func testGetLocationAPI()
    {
        let response = APITestUtils().getMockData(file: "LocationData")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let locationData = try? JSONDecoder().decode(LocationResponse.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(locationData)
    
        XCTAssertNotNil(locationData.message?.stringValue)
        XCTAssertNotNil(locationData.data)
        XCTAssertNotNil(locationData.data?.count?.intValue)
        XCTAssertGreaterThan(locationResponse.data?.count, 0)
        XCTAssertNotNil(locationData.data?.count?.intValue)
        XCTAssertNotNil(locationData.data?.rows?[0].id?.intValue)
        XCTAssertNotNil(locationData.data?.rows?[0].name?.stringValue)
        XCTAssertNotNil(locationData.data?.rows?[0].address?.stringValue)
        XCTAssertNotNil(locationData.data?.rows?[0].latitude?.doubleValue)
        XCTAssertNotNil(locationData.data?.rows?[0].longitude?.doubleValue)
        XCTAssertNotNil(locationData.data?.rows?[0].support_phone?.stringValue)
        XCTAssertNotNil(locationData.data?.rows?[0].distance?.stringValue)
        XCTAssertNotEqual(locationData.data?.rows?[0].facilities?.count, 0)
        XCTAssertNotNil(locationData.data?.rows?[0].facilities?[0].name?.stringValue)
        XCTAssertNotNil(locationData.data?.rows?[0].type?.name?.stringValue)
    }

}
