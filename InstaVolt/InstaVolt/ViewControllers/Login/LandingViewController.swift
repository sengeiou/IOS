//
//  LandingViewController.swift
//  InstaVolt
//
//  Created by PCQ111 on 15/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController
{
    //Mark:- Outlets -
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    
    //MARK:- Variables -
    
    
    //MARK:- Life Cycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK:- Action Methods -
    @IBAction func signUp(_ sender: Any)
    {
        moveToRegisterScreen()
    }
    
    @IBAction func signIn(_ sender: Any)
    {
        moveToLoginScreen()
    }
    
    @IBAction func skip(_ sender: Any)
    {
        let userType:UserType = .guestUser
        print(userType.rawValue)
        
        UserDefault[Key.userType] = userType.rawValue
        moveToHomeScreen()
    }
}

//MARK:- Navigations Methods -
extension LandingViewController
{
    func moveToLoginScreen()
    {
        if let loginScreen = R.storyboard.login.loginViewController()
        {
            navigationController?.pushViewController(loginScreen, animated: true)
        }
    }
    
    func moveToRegisterScreen()
    {
        if let registerScreen = R.storyboard.login.registerViewController()
        {
            navigationController?.pushViewController(registerScreen, animated: true)
        }
    }
    
    func moveToHomeScreen()
    {
        let mainViewController = MainSideBarViewController()
        let mapViewController = R.storyboard.main().getNavigationController(identifire: String.Identifier.mainNavigationController)
        mainViewController.rootViewController = mapViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
}
