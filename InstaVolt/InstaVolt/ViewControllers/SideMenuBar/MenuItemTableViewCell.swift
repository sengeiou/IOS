//
//  MenuItemTableViewCell.swift
//  InstaVolt
//
//  Created by PCQ177 on 15/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    //MARK:- Outlets -
    @IBOutlet weak var sideBarBackgroundView: UIView!
    @IBOutlet weak var imageViewMenuItem: UIImageView!
    @IBOutlet weak var labelMenuItem: UILabel!
    
    //MARK:- LifeCycle Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Custom Methods -
    func setup(with item: SideBarItemType, isSelected: Bool) {
        switch item {
        case .profile:
                labelMenuItem.text = "My Profile"
            imageViewMenuItem.image = isSelected ? R.image.selectedMyProfile() : R.image.myProfile()
        case .findStation:
             labelMenuItem.text = "Find a Charger"
             imageViewMenuItem.image = isSelected ? R.image.selectedlocation() : R.image.location()
        case .payment:
            labelMenuItem.text = "Payment"
            imageViewMenuItem.image = isSelected ? R.image.selectedPayment() : R.image.payment()
        case .faqs:
            labelMenuItem.text = "FAQ’s"
            imageViewMenuItem.image = isSelected ? R.image.selectedFaq() : R.image.faq()
        case .contactus:
            labelMenuItem.text = "Contact Us"
            imageViewMenuItem.image = isSelected ? R.image.selected_contactUs() : R.image.contact()
        case .signIn:
                labelMenuItem.text = "Register/Sign Up"
                imageViewMenuItem.image = isSelected ? R.image.selectedMyProfile() : R.image.myProfile()
        default:
            break
        }
        if isSelected {
            labelMenuItem.textColor = .white
            sideBarBackgroundView.backgroundColor = R.color.appRedColor()
        }
        else {
            labelMenuItem.textColor = R.color.navbarColor()
            sideBarBackgroundView.backgroundColor = .white
        }
    }

}
