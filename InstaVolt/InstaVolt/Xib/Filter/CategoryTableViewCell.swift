//
//  CategoryTableViewCell.swift
//  InstaVolt
//
//  Created by PCQ177 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    //MARK:- Outlets -
    @IBOutlet weak var labelCategory: UILabel!
    
    //MARK:- Variables -
    var filterCategory: FilterCategory? {
        didSet {
            labelCategory.text = filterCategory?.name
            if filterCategory?.isSelected ?? false
            {
                labelCategory.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
            }
            else
            {
                labelCategory.textColor = UIColor(red: 0.243, green: 0.243, blue: 0.243, alpha: 1.0)
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
