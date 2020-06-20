//
//  IVAnnotationView.swift
//  InstaVolt
//
//  Created by PCQ111 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import MapKit

private let multiWheelCycleClusterID = "multiWheelCycle"

/// - Tag: IVAnnotationView
class IVAnnotationView: MKAnnotationView
{
    static let ReuseID = "IVAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?)
    {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = multiWheelCycleClusterID
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
        
        if let annotation = self.annotation as? IVPointAnnotation
        {
            if(annotation.color == .red)
            {
                self.image = UIImage(named: "redIcon")
            }
            else
            {
                self.image = UIImage(named: "blackIcon")
            }
        }
    }
}
