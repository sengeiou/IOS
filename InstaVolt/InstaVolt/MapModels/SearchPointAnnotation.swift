//
//  SearchPointAnnotation.swift
//  InstaVolt
//
//  Created by PCQ111 on 19/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import MapKit

class SearchPointAnnotation : MKPointAnnotation
{
//    var location : Location?
//    var color : UIColor?
    
    init(coordinate : CLLocationCoordinate2D)
    {
        super.init()
        self.coordinate = coordinate
    }
}
