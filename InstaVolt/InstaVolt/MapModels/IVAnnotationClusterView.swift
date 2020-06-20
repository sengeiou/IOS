//
//  IVAnnotationClusterView.swift
//  InstaVolt
//
//  Created by PCQ111 on 11/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import Foundation
import MapKit

/// - Tag: IVAnnotationClusterView
class IVAnnotationClusterView: MKAnnotationView
{
    static let ReuseID = "IVAnnotationClusterView"
    override init(annotation: MKAnnotation?, reuseIdentifier: String?)
    {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: CustomCluster
    override func prepareForDisplay()
    {
        super.prepareForDisplay()
        if let cluster = annotation as? MKClusterAnnotation
        {
            let totalStations = cluster.memberAnnotations.count
            image = drawStationCount(count: totalStations)
            displayPriority = .defaultHigh
        }
    }

    private func drawStationCount(count: Int) -> UIImage
    {
        return drawRatio(0, to: count, fractionColor: nil, wholeColor: UIColor.colorWithRGB(red: 183.0, green: 50.0, blue: 31.0, alpha: 1.0))
    }
    
    private func retunSizeForCluster(count: Int) -> CGFloat
    {
        if(count > 0 && count < 10)
        {
            return 40.0
        }
        else if(count >= 10 && count < 100)
        {
            return 60.0
        }
        else if(count >= 100 && count < 1000)
        {
            return 80.0
        }
        else
        {
            return 100.0
        }
    }
    
    private func getOvalWidth(count: Int) -> CGFloat
    {
        if(count > 0 && count < 10)
        {
            return 6.0
        }
        else if(count >= 10 && count < 100)
        {
            return 9.0
        }
        else if(count >= 100 && count < 1000)
        {
            return 12.0
        }
        else
        {
            return 15.0
        }
    }

    private func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage
    {
        let width = retunSizeForCluster(count: whole)
        let ovalWidth = getOvalWidth(count: whole)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: width))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: width, height: width)).fill()

            // Fill pie with fractionColor
            fractionColor?.setFill()
            let piePath = UIBezierPath()
            piePath.addArc(withCenter: CGPoint(x: width/2, y: width/2), radius: width/2, startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole), clockwise: true)
            piePath.addLine(to: CGPoint(x: 20, y: 20))
            piePath.close()
            piePath.fill()

            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: ovalWidth, y: ovalWidth, width: width - ovalWidth * 2.0, height: width - ovalWidth * 2.0)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
            
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: width/2 - size.width / 2, y: width/2 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
