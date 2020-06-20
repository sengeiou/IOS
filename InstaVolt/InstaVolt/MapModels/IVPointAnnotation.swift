//
//  IVPointAnnotation.swift
//  InstaVolt
//
//  Created by PCQ111 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import MapKit

class IVPointAnnotation : MKPointAnnotation
{
    var location : Location?
    var color : UIColor?
    
    init(coordinate : CLLocationCoordinate2D, location : Location?)
    {
        super.init()
        self.coordinate = coordinate
        self.location = location
        
        if(location?.available_stations == 0 && location?.in_use_stations == 0)
        {
            color = .black
        }
        else
        {
            color = .red
        }
    }
}
