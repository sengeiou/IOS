//
//  SearchAnnotationView.swift
//  InstaVolt
//
//  Created by PCQ111 on 19/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import MapKit

private let searchmultiWheelCycleClusterID = "searchmultiWheelCycle"

/// - Tag: IVAnnotationView
class SearchAnnotationView: MKAnnotationView
{
    static let ReuseID = "SearchAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?)
    {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = searchmultiWheelCycleClusterID
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: DisplayConfiguration
    override func prepareForDisplay()
    {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        
        if let annotation = self.annotation as? SearchPointAnnotation
        {
            self.image = UIImage(named: "searchedLocation")
        }
    }
}
