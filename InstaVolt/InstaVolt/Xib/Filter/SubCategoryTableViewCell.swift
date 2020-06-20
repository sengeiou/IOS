//
//  SubCategoryTableViewCell.swift
//  InstaVolt
//
//  Created by PCQ177 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    
    //MARK:- Outlets -
    @IBOutlet weak var imageViewTick: UIImageView!
    @IBOutlet weak var labelSubCategory: UILabel!
    
    //MARK:- Variables -
    var subCategory: FilterSubCategoryDetail? {
        didSet
        {
            labelSubCategory.text = subCategory?.name?.stringValue
            if subCategory?.isSelected ?? false {
                labelSubCategory.textColor = UIColor(red: 0.718, green: 0.196, blue: 0.121, alpha: 1.0)
                imageViewTick.image = R.image.selecedFilterTick()
            } else {
                labelSubCategory.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                imageViewTick.image = UIImage()
            }
        }
    }
    
    //MARK:- LifeCycle Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
