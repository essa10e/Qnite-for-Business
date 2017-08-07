//
//  VerificationViewController.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-08-05.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD

class VerificationViewController: UIViewController {

    var tokens = [String: String]()
    
    @IBOutlet weak var tokenField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTokens()
    }

    func fetchTokens() {
        DBProvider.Instance.venueInfoRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? [String: Any] {
                for (key,value) in data {
                    if let user = value as? [String: Any] {
                        if let token = user["employee_token"] as? String {
                            let pageId = key 
                            self.tokens.updateValue(token, forKey: pageId)
                        }
                    }
                }
            }
        }
    }
    
    func checkToken(enteredToken: String) {
        for (pageId, pageToken) in tokens {
            if enteredToken == pageToken {
                DBProvider.Instance.venueInfoRef.child(pageId).child(FIR_EVENT_INFO.NAME).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    if let pageName = snapshot.value as? String {
                        self.showSuccess(name: pageName, completion: {
                            FacebookUser.Instance.tokenAuthorized(pageName: pageName, pageId: pageId)
                            DBProvider.Instance.tokenAuthorized(pageId: pageId)
                            self.performSegue(withIdentifier: "tokenSegue", sender: self)

                        })
                    }
                })
                
            }
            else {
                showError(status: "Token not found, please try again.")
            }
        }
        
        
    }
    
    // TODO
    // fetch all access tokens at view did load
    // recheck equality after each key stroke, automatically verify when correct serial is entered
    @IBAction func infoAction(_ sender: Any) {
         performSegue(withIdentifier: "tokenSegue", sender: self)
    }
    @IBAction func tokenFieldChanged(_ sender: Any) {
        if tokenField.text?.characters.count == 10 {
            
            checkToken(enteredToken: tokenField.text!)
        }
    }

    
    func showSuccess(name: String, completion: @escaping () -> ()) {
       
        SVProgressHUD.setFadeInAnimationDuration(0.2)
        SVProgressHUD.setFadeOutAnimationDuration(0.2)
        SVProgressHUD.showSuccess(withStatus: "\(name)")
        SVProgressHUD.dismiss(withDelay: 1, completion: completion)
    }
    
    func showError(status: String) {
        
        // add small x to lcear field
        
        SVProgressHUD.setFadeInAnimationDuration(0.2)
        SVProgressHUD.setFadeOutAnimationDuration(0.2)
        SVProgressHUD.showError(withStatus: status)
        SVProgressHUD.dismiss(withDelay: 1) {
            
        }
    }
}
