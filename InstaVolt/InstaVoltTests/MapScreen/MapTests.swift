//
//  MapTests.swift
//  InstaVoltTests
//
//  Created by PCQ111 on 11/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import XCTest
import MapKit
import CoreLocation
@testable import InstaVolt

class MapTests: XCTestCase
{
    func testGetChargeStationOnMapAPI()
    {
        let response = APITestUtils().getMockData(file: "LocationData")
        let jsonData = (try? JSONSerialization.data(withJSONObject: response))!
        guard let locationResponse = try? JSONDecoder().decode(LocationResponse.self, from: jsonData) else {
            XCTFail()
            return
        }
        XCTAssertNotNil(locationResponse)
    
        XCTAssertNotNil(locationResponse.message?.stringValue)
        XCTAssertNotNil(locationResponse.data)
        XCTAssertNotNil(locationResponse.data?.count?.intValue)
        XCTAssertNotEqual(locationResponse.data?.rows?.count, 0)
        XCTAssertNotNil(locationResponse.data?.count?.intValue)
        XCTAssertNotNil(locationResponse.data?.rows?[0].id?.intValue)
        XCTAssertNotNil(locationResponse.data?.rows?[0].name?.stringValue)
        XCTAssertNotNil(locationResponse.data?.rows?[0].address?.stringValue)
        XCTAssertNotNil(locationResponse.data?.rows?[0].latitude?.doubleValue)
        XCTAssertNotNil(locationResponse.data?.rows?[0].longitude?.doubleValue)
        XCTAssertNotNil(locationResponse.data?.rows?[0].support_phone?.stringValue)
        XCTAssertNotNil(locationResponse.data?.rows?[0].distance?.stringValue)
        XCTAssertNotEqual(locationResponse.data?.rows?[0].facilities?.count, 0)
        XCTAssertNotNil(locationResponse.data?.rows?[0].facilities?[0].name?.stringValue)
        XCTAssertNotNil(locationResponse.data?.rows?[0].type?.name?.stringValue)
    }
    
    func testMinDistance()
    {
        let currentLocation = CLLocation(latitude: 51.378272, longitude: -0.013854)
        
        var arrayOfLocation = [Location]()
        
        arrayOfLocation.append(Location(from : Generic(51.378274), longitude : Generic(-0.013856)))
        arrayOfLocation.append(Location(from : Generic(51.375604), longitude : Generic(0.009458)))
        arrayOfLocation.append(Location(from : Generic(51.375607), longitude : Generic(0.009456)))

        let closestLocation = Utility.closestLocation(locations: arrayOfLocation, closestToLocation: currentLocation)
        
        XCTAssertNotNil(closestLocation)
    }
}
