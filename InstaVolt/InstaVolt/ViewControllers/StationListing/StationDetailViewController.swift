//
//  StationDetailViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 12/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class StationDetailViewController: UIViewController {

    //MARK:- Outlets -
    
    //MARK:- Variables -
    
    //MARK:- LifeCycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Webservice Methods -
    
    //MARK:- Action Methods -
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Custom Methods -

}
