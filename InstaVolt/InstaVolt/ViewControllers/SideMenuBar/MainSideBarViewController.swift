//
//  MainSideBarViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 15/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import LGSideMenuController

class MainSideBarViewController: LGSideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    func setUp()
    {
        leftViewController = R.storyboard.profile.sideMenuBarViewController()
        leftViewWidth = UIScreen.main.bounds.width * 0.70
        leftViewBackgroundColor = .white
        isLeftViewSwipeGestureEnabled = true
//        let coverColor = UIColor.black.withAlphaComponent(0.2)
        leftViewPresentationStyle = .scaleFromBig
//        rootViewCoverColorForLeftView = .clear
        rootViewScaleForLeftView = 0.78
    }


}
