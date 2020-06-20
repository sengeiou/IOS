//
//  ContactUsViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 22/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import SafariServices

class ContactUsViewController: BaseViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var labelPhoneNumber       : UILabel!
    @IBOutlet weak var labelEmail             : UILabel!
    @IBOutlet weak var labelAddress           : UILabel!
    @IBOutlet weak var viewPhoneNumber        : UIView!
    @IBOutlet weak var viewEmail              : UIView!
    @IBOutlet weak var viewAddress            : UIView!
    @IBOutlet weak var contactContainingView  : UIStackView!
    
    
    //MARK:- Variables -
    var contactUs: ContactUs?
    
    //MARK:- Lifecycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareContactUsView()
    }
    
    //MARK:- View Methods -
    private func prepareContactUsView()
    {
        viewPhoneNumber.dropShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.12), opacity: 1.0, offSet: CGSize(width: 0, height: 2), radius: 2.0, scale: false)
        viewEmail.dropShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.12), opacity: 1.0, offSet: CGSize(width: 0, height: 2), radius: 2.0, scale: false)
        viewAddress.dropShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.12), opacity: 1.0, offSet: CGSize(width: 0, height: 2), radius: 2.0, scale: false)
        self.callContactUSAPI()
    }
    
    //MARK:- Webservice Methods -
    private func callContactUSAPI() {
        self.startLoading()
        SettingController.shared.getContactUsDetail(successCompletion: { (contactus) in
            self.contactUs = contactus
            self.setContactUsData()
            self.stopLoading()
        }) { (error, errorResponse) in
            self.showAlert(message: error.errorMessage ?? String.Title.errorMessage)
            self.stopLoading()
        }
//        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObject.contactUS))!
//        contactUs = try? JSONDecoder().decode(ContactUs.self, from: jsonData)
//        print(contactUs)
    }
    
    
    //MARK:- Action Methods -
    @IBAction func phoneButton(_ sender: UIButton) {
        let number = contactUs?.data?.phone?.stringValue
        if let url = URL(string: "tel://\(number ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func emailButton(_ sender: UIButton) {
        let emailID = contactUs?.data?.email?.stringValue
        if let url = URL(string: "mailto:\(emailID ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func menuButton(_ sender: UIButton)
    {
        let sideBar = self.sideMenuController as! MainSideBarViewController
        sideBar.showLeftViewAnimated()
    }
    
    @IBAction func addressButton(_ sender: UIButton)
    {
        let svc = SFSafariViewController(url: URL(string: "https://instavolt.co.uk/contact/")!)
        self.present(svc, animated: true, completion: nil)
    }
    
    //MARK:- Set Data Method -
    private func setContactUsData()
    {
        if contactUs?.data?.phone != "" && contactUs?.data?.phone != nil
        {
            labelPhoneNumber.text = contactUs?.data?.phone?.stringValue
        }
        else
        {
            for view in contactContainingView.subviews {
                if view == viewPhoneNumber
                {
                    contactContainingView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                    //                    view.isHidden = true
                }
            }
        }
        if contactUs?.data?.email != "" && contactUs?.data?.email != nil
        {
            labelEmail.text = contactUs?.data?.email?.stringValue
        }
        else
        {
            for view in contactContainingView.subviews {
                if view == viewEmail
                {
                    contactContainingView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                    //                    view.isHidden = true
                }
            }
        }
        if contactUs?.data?.address != "" && contactUs?.data?.address != nil
        {
            labelAddress.text = contactUs?.data?.address?.stringValue
        }
        else
        {
            for view in contactContainingView.subviews {
                if view == viewAddress
                {
                    contactContainingView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                    //                    view.isHidden = true
                }
            }
        }
        contactContainingView.isHidden = false
    }
    
    //MARK:- Custom Methods -
}

