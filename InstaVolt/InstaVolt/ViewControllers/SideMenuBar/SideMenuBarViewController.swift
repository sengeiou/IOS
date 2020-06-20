//
//  SideMenuBarViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 15/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import AWSMobileClient
import LGSideMenuController

class SideMenuBarViewController: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var tableViewMenuItems: UITableView!
    @IBOutlet weak var buttonLogout: UIButton!
    
    //MARK:- Variables -
    var items: [SideBarItemType] = []
    var selectedItem = SideBarItemType.findStation
    
    //MARK:- Lifecycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let sideBarViewController = sideMenuController as? MainSideBarViewController {
        sideBarViewController.delegate = self
        }
    }
    
    //MARK:- View Methods -
    private func prepareSideMenu()
    {
        if UserDefault[Key.userType] as? Int == 1
        {
            items = [SideBarItemType.signIn,SideBarItemType.findStation,SideBarItemType.faqs,SideBarItemType.contactus]
            buttonLogout.isHidden = true
            labelUserName.text = "Guest User"
        }
        else
        {
            items = [SideBarItemType.profile,SideBarItemType.findStation,SideBarItemType.payment,SideBarItemType.faqs,SideBarItemType.contactus]
            buttonLogout.isHidden = false
            labelUserName.text = (userDetail?.first_name?.stringValue ?? "") + " " + (userDetail?.last_name?.stringValue ?? "")
        }
        tableViewMenuItems.reloadData()
    }
    
    //MARK:- Webservice Methods -
    
    //MARK:- Action Methods -
    @IBAction func logoutButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "driverOtherDataDefault")
        UserDefaults.standard.removeObject(forKey: "driverDefault")
        UserDefaults.standard.removeObject(forKey: Key.userType)
        UserDefaults.standard.removeObject(forKey: Key.loginType)
        
        KeyChainManager.shared.clearAccessToken()
        KeyChainManager.shared.clearPassword()
        
        AWSMobileClient.default().signOut()
        APIManager.API.removeAuthorizeToken()
        IVApplication.shared.moveToLoginScreen()
    }
    
    
    //MARK:- Custom Methods -
    func moveTo(menuItem: SideBarItemType)
    {
        guard let sideBarViewController = self.sideMenuController as? MainSideBarViewController else { return }
        sideBarViewController.hideLeftView()
        switch menuItem {
        case .profile:
            let profileVC = R.storyboard.profile().getNavigationController(identifire: String.Identifier.profileNavigationController)
            sideBarViewController.rootViewController = profileVC
        case .findStation:
            let stationVC = R.storyboard.main().getNavigationController(identifire: String.Identifier.mainNavigationController)
            sideBarViewController.rootViewController = stationVC
        case .payment:
            let paymentVC = R.storyboard.payment().getNavigationController(identifire: String.Identifier.paymentNavigationController)
            sideBarViewController.rootViewController = paymentVC
        case .faqs:
            let faqVC = R.storyboard.setting().getNavigationController(identifire: String.Identifier.faqNavigationController)
            sideBarViewController.rootViewController = faqVC
        case .contactus:
            let contactUSVC = R.storyboard.setting().getNavigationController(identifire: String.Identifier.settingNavigationController)
            sideBarViewController.rootViewController = contactUSVC
        case .signIn:
            let landingVC = R.storyboard.login().getNavigationController(identifire: String.Identifier.loginNavigationController)
            sideBarViewController.rootViewController = landingVC
        default:
            print("Default case")
        }
    }
}
//MARK:- Table View Delegate & Data Source -
extension SideMenuBarViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as? MenuItemTableViewCell
        cell!.setup(with: items[indexPath.row], isSelected: items[indexPath.row] == selectedItem)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        moveTo(menuItem: selectedItem)
        tableView.reloadData()
    }
}
//LGSide Menu Delegate -
extension SideMenuBarViewController: LGSideMenuDelegate
{
    func willShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        sideMenuController.rootViewController?.view.layer.cornerRadius = 20.0
        sideMenuController.rootViewController?.view.layer.borderWidth = 2.0
        sideMenuController.rootViewController?.view.layer.borderColor = UIColor(red: 0.945, green: 0.945, blue: 0.945, alpha: 1.0).cgColor
        sideMenuController.rootViewController?.view.clipsToBounds = true
    }
    
    func willHideLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        sideMenuController.rootViewController?.view.layer.cornerRadius = 0.0
        sideMenuController.rootViewController?.view.layer.borderWidth = 0.0
    }
}
