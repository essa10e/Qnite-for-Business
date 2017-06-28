//
//  LoginViewController.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-28.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var loginButton = FBSDKLoginButton()

    @IBOutlet weak var loginButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.showLoginButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() != nil {
            
            AuthProvider.Instance.login(loginHandler: { (message) in
                if message != nil {
                    self.alertUser(title: "Problem With Login", message: message!)
                }
                else {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            })
            
        }

    }
    func showLoginButton() {
        self.loginButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50) // change to constraints
        self.loginButton.delegate = self
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.delegate = self
        loginButton.readPermissions = ["public_profile","email","user_birthday"]
        self.loginButtonView.addSubview(loginButton)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            if result.declinedPermissions.contains("public_profile") {
                alertUser(title: "Problem with Login", message: "Permissions need to be accepted for Qnite to function properly")
            }
        }
        else {
            AuthProvider.Instance.login(loginHandler: { (message) in
                if message != nil {
                    self.alertUser(title: "Problem with Login", message: message!)
                }
                else {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // should not ever get here
        _ = AuthProvider.Instance.logout()
    }

    
    func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}
