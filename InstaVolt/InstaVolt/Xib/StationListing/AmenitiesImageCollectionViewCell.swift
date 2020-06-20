//
//  AmenitiesImageCollectionViewCell.swift
//  InstaVolt
//
//  Created by PCQ177 on 11/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import SDWebImage

class AmenitiesImageCollectionViewCell: UICollectionViewCell {

    //MARK:- Outlets -
    @IBOutlet weak var imageViewAmenities: UIImageView!
    
    //MARK:- Variables -
    var faility: Facilities?
    {
        didSet {
            imageViewAmenities.sd_setImage(with: URL(string: faility?.image?.stringValue ?? ""), placeholderImage: UIImage(), options: [], context: nil)
//            print(faility?.image?.stringValue)
        }
    }
    
    //MARK:- LifeCycle Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
