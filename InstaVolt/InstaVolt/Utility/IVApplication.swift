//
//  IVApplication.swift
//  InstaVolt
//
//  Created by PCQ111 on 14/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import Rswift
import AWSMobileClient

class IVApplication
{
    static let shared = IVApplication()
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var reachability : Reachability?
    private let reachabilityManager = NetworkReachabilityManager()
    
    
    init()
    {
        
    }
    
    func prepareView()
    {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .black
        
        checkInternetRechability()
        callGetFilterAPI()
        
        // Initialize AWSMobileClient singleton
        AWSMobileClient.default().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        prepareNavigation()
    }
    
    private func checkInternetRechability()
    {
        self.reachability = Reachability()
        do
        {
            try reachability?.startNotifier()
        }
        catch
        {
            print( "ERROR: Could not start reachability notifier." )
        }
        self.startNetworkReachabilityObserver()
    }
    
    @objc private func startNetworkReachabilityObserver()
    {
        reachabilityManager?.listener = { status in
            
            switch status
            {
            case .reachable:
                
                print("INTERNET STATUS : AVAIALBALE")
                break
            case .notReachable:
                
                print("INTERNET STATUS : NOT AVAIALBALE")
                
                break
            case .unknown :
                print("INTERNET STATUS : UNAVAILABLE")
                
                break
            }
        }
        reachabilityManager?.startListening()
    }
    
    
    private func prepareNavigation()
    {
        let userType = UserDefault[Key.userType] as? Int ?? 0
        print(userType)
        
        if(userType == 0) //no guest, no driver
        {
            moveToLoginScreen()
        }
        else if(userType == 1) //guest
        {
            moveToHomeScreen()
        }
        else//driver
        {
            if let driver = DriverManager.driver()
            {
                userDetail = driver
                print(driver.first_name?.stringValue ?? "")

                if(driver.is_profile_verified?.boolValue ?? false)
                {
                    //home
                    moveToHomeScreen()
                }
                else
                {
                    moveToProfileScreen()
                }
            }
            else
            {
                //login
                moveToLoginScreen()
            }
        }
        if let token = KeyChainManager.shared.loadAccessToken() , userType != 0, token != ""
        {
            APIManager.API.header["Authorization"] = token as String
        }
        else
        {
            KeyChainManager.shared.clearAccessToken()
            KeyChainManager.shared.clearPassword()
        }
    }
    
    func moveToLoginScreen()
    {
        IVApplication.appDelegate.window?.rootViewController = R.storyboard.login().getNavigationController(identifire: String.Identifier.loginNavigationController)
        IVApplication.appDelegate.window?.makeKeyAndVisible()
    }
    
    func moveToHomeScreen()
    {
        let mainViewController = MainSideBarViewController()
        let mapViewController = R.storyboard.main().getNavigationController(identifire: String.Identifier.mainNavigationController)
        mainViewController.rootViewController = mapViewController
        IVApplication.appDelegate.window?.rootViewController = mainViewController
        IVApplication.appDelegate.window?.makeKeyAndVisible()
    }
    
    func moveToProfileScreen()
    {
        let mainViewController = MainSideBarViewController()
        let mapViewController = R.storyboard.profile().getNavigationController(identifire: String.Identifier.profileNavigationController)
        mainViewController.rootViewController = mapViewController
        IVApplication.appDelegate.window?.rootViewController = mainViewController
        if let sideMenu = mainViewController.leftViewController as? SideMenuBarViewController
        {
            sideMenu.selectedItem = .profile
            sideMenu.tableViewMenuItems.reloadData()
        }
        let viewControllers = mapViewController.viewControllers
        for vc in viewControllers
        {
            if vc.isKind(of: ProfileViewController.self)
            {
                let profileController = vc as! ProfileViewController
                profileController.isFromSignUp = true
                profileController.shouldHideCancelButton = true
                profileController.shouldHideForgotPassword = true
                profileController.shouldHideCancelAccount = true
            }
        }
        IVApplication.appDelegate.window?.makeKeyAndVisible()
    }
    
    func goToViewController()
    {
        IVApplication.appDelegate.window?.rootViewController = R.storyboard.main().getNavigationController(identifire: String.Identifier.mainNavigationController)
        IVApplication.appDelegate.window?.makeKeyAndVisible()

    }
}
