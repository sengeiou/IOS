//
//  FAQViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 26/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import WebKit

class FAQViewController: BaseViewController {

    //MARK:- Outlets -
    @IBOutlet weak var webviewContainerView: UIView!
    
    //MARK:- Variables -
    let wkWebView: WKWebView = {
        let v = WKWebView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //MARK:- Lifecycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareFAQView()
    }
    
    //MARK:- View Methods -
    private func prepareFAQView() {
        webviewContainerView.addSubview(wkWebView)
        wkWebView.topAnchor.constraint(equalTo: webviewContainerView.topAnchor, constant: 0.0).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: webviewContainerView.bottomAnchor, constant: 0.0).isActive = true
        wkWebView.leadingAnchor.constraint(equalTo: webviewContainerView.leadingAnchor, constant: 0.0).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: webviewContainerView.trailingAnchor, constant: 0.0).isActive = true
        callFAQAPI()
    }
    
    private func callFAQAPI()
    {
        self.startLoading()
        SettingController.shared.getContactUsDetail(successCompletion: { (contactUS) in
            if let faqURL = contactUS.data?.faqURL?.stringValue
            {
                if let url = URL(string: "\(faqURL)") {
                    self.wkWebView.load(URLRequest(url: url))
                }
            }
            self.stopLoading()
        }) { (error, errorResponse) in
            self.startLoading()
            self.showValidationMessage(withMessage: error.errorMessage)
        }
    }
    
    //MARK:- Webservice Methods -
    
    //MARK:- Action Methods -
    @IBAction func menuButton(_ sender: UIButton) {
        let sideBar = self.sideMenuController as! MainSideBarViewController
               sideBar.showLeftViewAnimated()
    }
    
    
    //MARK:- Custom Methods -
    
}
