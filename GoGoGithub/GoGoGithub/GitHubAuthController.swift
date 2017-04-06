//
//  GitHubAuthController.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/3/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

class GitHubAuthController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateUI() {
        if let _ = UserDefaults.standard.getAccessToken() {
            // disable your button, change color
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = UIColor.gray
            //enable button, change color back to original
        } else {
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = UIColor(red: 0,
                                                       green: 255/255,
                                                       blue: 128/255,
                                                       alpha: 1)
        }
    }
    
    @IBAction func printTokenPressed(_ sender: Any) {
        
        //print accessToken
        let accessToken = UserDefaults.standard.getAccessToken()
        
        print("Access Token: \(String(describing: accessToken))")
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        //request OAuth
        let parameters = ["scope" : "email,user,repo"]
        
        GitHub.shared.oAuthRequestWith(parameters: parameters)
        
        updateUI()
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "access_token")
        updateUI()
    }
    
    //take view off parent view, and parent viewcontroller
    func dismissAuthController() {
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
    }
}
