//
//  Utility.swift
//  InstaVolt
//
//  Created by PCQ111 on 12/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import CoreLocation

class Utility
{
    class func closestLocation(locations: [Location], closestToLocation location: CLLocation) -> CLLocation?
    {
        if let closestLocation = locations.min(by: { location.distance(from: $0.getCLLocation()) < location.distance(from: $1.getCLLocation()) })
        {
            print("closest location: \(closestLocation), distance: \(location.distance(from: closestLocation.getCLLocation()))")
            return closestLocation.getCLLocation()
        }
        else
        {
            print("coordinates is empty")
            return nil
        }
    }
}


