//
//  TermsAndConditionViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 25/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import WebKit

protocol TermsAndCondition {
    func acceptTermsAndCondition()
    func declineTermsAndCondition()
}

class TermsAndConditionViewController: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var webViewContainerView: UIView!
    @IBOutlet var popControllerTapGesture: UITapGestureRecognizer!
    
    //MARK:- Variables -
    let wkWebView: WKWebView = {
        let v = WKWebView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var termsAndConditionDelegate: TermsAndCondition?
    
    //MARK:- Lifecycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTermsAndConditionView()
    }
    
    //MARK:- View Methods -
    private func prepareTermsAndConditionView()
    {
        self.view.addGestureRecognizer(popControllerTapGesture)
        webViewContainerView.addSubview(wkWebView)
        wkWebView.topAnchor.constraint(equalTo: webViewContainerView.topAnchor, constant: 0.0).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: webViewContainerView.bottomAnchor, constant: 0.0).isActive = true
        wkWebView.leadingAnchor.constraint(equalTo: webViewContainerView.leadingAnchor, constant: 0.0).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: webViewContainerView.trailingAnchor, constant: 0.0).isActive = true
        if let url = URL(string: String.URL.termsAndConditonURL) {
            wkWebView.load(URLRequest(url: url))
        }
    }
    
    //MARK:- Webservice Methods -
    
    //MARK:- Action Methods -
    @IBAction func accept(_ sender: UIButton)
    {
        termsAndConditionDelegate?.acceptTermsAndCondition()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func decline(_ sender: UIButton)
    {
        termsAndConditionDelegate?.declineTermsAndCondition()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Custom Methods -
}
