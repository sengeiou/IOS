//
//  FilterViewTests.swift
//  InstaVoltTests
//
//  Created by PCQ177 on 10/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
@testable import InstaVolt

class FilterViewTests: XCTestCase {
    
    func testCallGetFilterAPI()
    {
        let response = APITestUtils().getMockData(file: "FilterCategory")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let filterCategory = try? JSONDecoder().decode(FilterSubCategory.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(filterCategory)
        XCTAssertNotNil(filterCategory.data)
        XCTAssertNotNil(filterCategory.data?.amenities)
        XCTAssertNotEqual(filterCategory.data?.amenities?.count, 0)
        XCTAssertNotNil(filterCategory.data?.status)
        XCTAssertNotEqual(filterCategory.data?.status?.count, 0)
        XCTAssertNotNil(filterCategory.data?.power_types)
        XCTAssertNotEqual(filterCategory.data?.power_types?.count, 0)
        XCTAssertNotNil(filterCategory.data?.connector_types)
        XCTAssertNotEqual(filterCategory.data?.connector_types?.count, 0)
        XCTAssertNotNil(filterCategory.data?.network)
        XCTAssertNotEqual(filterCategory.data?.network?.count, 0)
        XCTAssertNotNil(filterCategory.data?.amenities?[0].id?.intValue)
        XCTAssertNotNil(filterCategory.data?.amenities?[0].name?.stringValue)
        XCTAssertNotNil(filterCategory.data?.amenities?[0].defaultSearch?.boolValue)
        XCTAssertNotNil(filterCategory.data?.amenities?[0].code?.stringValue)
        XCTAssertNotNil(filterCategory.data?.amenities?[0].description?.stringValue)
        XCTAssertNil(filterCategory.data?.amenities?[0].image?.stringValue)
        XCTAssertNotNil(filterCategory.data?.amenities?[0].lookupId?.stringValue)
        XCTAssertNil(filterCategory.data?.amenities?[0].color?.stringValue)
        XCTAssertNotNil(filterCategory.data?.amenities?[0].active?.boolValue)
        XCTAssertNotNil(filterCategory.data?.status?[0].id?.intValue)
        XCTAssertNotNil(filterCategory.data?.status?[0].name?.stringValue)
        XCTAssertNotNil(filterCategory.data?.status?[0].defaultSearch?.boolValue)
        XCTAssertNotNil(filterCategory.data?.status?[0].code?.stringValue)
        XCTAssertNotNil(filterCategory.data?.status?[0].description?.stringValue)
        XCTAssertNil(filterCategory.data?.status?[0].image?.stringValue)
        XCTAssertNotNil(filterCategory.data?.status?[0].lookupId?.stringValue)
        XCTAssertNil(filterCategory.data?.status?[0].color?.stringValue)
        XCTAssertNotNil(filterCategory.data?.status?[0].active?.boolValue)
        XCTAssertNotNil(filterCategory.data?.power_types?[0].id?.intValue)
        XCTAssertNotNil(filterCategory.data?.power_types?[0].name?.stringValue)
        XCTAssertNotNil(filterCategory.data?.power_types?[0].defaultSearch?.boolValue)
        XCTAssertNotNil(filterCategory.data?.power_types?[0].code?.stringValue)
        XCTAssertNotNil(filterCategory.data?.power_types?[0].description?.stringValue)
        XCTAssertNil(filterCategory.data?.power_types?[0].image?.stringValue)
        XCTAssertNotNil(filterCategory.data?.power_types?[0].lookupId?.stringValue)
        XCTAssertNil(filterCategory.data?.power_types?[0].color?.stringValue)
        XCTAssertNotNil(filterCategory.data?.power_types?[0].active?.boolValue)
        XCTAssertNotNil(filterCategory.data?.connector_types?[0].id?.intValue)
        XCTAssertNotNil(filterCategory.data?.connector_types?[0].name?.stringValue)
        XCTAssertNotNil(filterCategory.data?.connector_types?[0].defaultSearch?.boolValue)
        XCTAssertNotNil(filterCategory.data?.connector_types?[0].code?.stringValue)
        XCTAssertNotNil(filterCategory.data?.connector_types?[0].description?.stringValue)
        XCTAssertNil(filterCategory.data?.connector_types?[0].image?.stringValue)
        XCTAssertNotNil(filterCategory.data?.connector_types?[0].lookupId?.stringValue)
        XCTAssertNil(filterCategory.data?.connector_types?[0].color?.stringValue)
        XCTAssertNotNil(filterCategory.data?.connector_types?[0].active?.boolValue)
        XCTAssertNotNil(filterCategory.data?.network?[0].id?.intValue)
        XCTAssertNotNil(filterCategory.data?.network?[0].name?.stringValue)
        XCTAssertNotNil(filterCategory.data?.network?[0].defaultSearch?.boolValue)
        XCTAssertNotNil(filterCategory.data?.network?[0].code?.stringValue)
        XCTAssertNotNil(filterCategory.data?.network?[0].description?.stringValue)
        XCTAssertNil(filterCategory.data?.network?[0].image?.stringValue)
        XCTAssertNotNil(filterCategory.data?.network?[0].lookupId?.stringValue)
        XCTAssertNil(filterCategory.data?.network?[0].color?.stringValue)
        XCTAssertNotNil(filterCategory.data?.network?[0].active?.boolValue)
    }
}
