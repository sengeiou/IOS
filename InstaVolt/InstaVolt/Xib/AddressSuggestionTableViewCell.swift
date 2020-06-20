//
//  AddressSuggestionTableViewCell.swift
//  InstaVolt
//
//  Created by PCQ177 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class AddressSuggestionTableViewCell: UITableViewCell {

    //MARK:- Outlets -
    @IBOutlet weak var labelAddress: UILabel!
    
    //MARK:- Variables -
    var address: String? {
        didSet {
            labelAddress.text = address?.replacingOccurrences(of: ", , , , ,", with: ",").replacingOccurrences(of: ", , , ,", with: ",").replacingOccurrences(of: ", , ,", with: ",").replacingOccurrences(of: ", ,", with: ",")
        }
    }
    
    //MARK:- LifecCycle Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
