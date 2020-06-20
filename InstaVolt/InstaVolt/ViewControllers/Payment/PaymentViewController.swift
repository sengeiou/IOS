//
//  PaymentViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 16/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    //MARK:- LifeCycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Action Methods -
    @IBAction func menuButton(_ sender: UIButton) {
        let sideBar = self.sideMenuController as! MainSideBarViewController
        sideBar.showLeftViewAnimated()
    }
    
}
