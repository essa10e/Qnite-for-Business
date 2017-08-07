//
//  AuthProvider.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-28.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

typealias LoginHandler = (_ msg: String?) -> Void

class AuthProvider {
    private static let _instance = AuthProvider()
    static var Instance: AuthProvider {
        return _instance
    }
    
    let fetchFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    
    func login(loginHandler: LoginHandler?) { // need to handle when user declines permissions
        let accessToken =  FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            loginHandler?("You need to login to Facebook to use Qnite")
            return
        }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
            }
            else {
                self.fetchData(loginHandler: loginHandler)
            }
        })
        
    }
    
    func fetchData(loginHandler: LoginHandler?) {
        FBProvider.Instance.graphRequest(pageID: "/me", fetchParameters: FB_USER_FETCH_PARAMS) { (connection, result, error) in
            if error != nil {
                // graph request fail
                return
            }
            let allResults = result as! [String: AnyObject]
            let id = allResults["id"] as? String
            let name = allResults["name"] as? String
            var email = allResults["email"] as? String
            let gender = allResults["gender"] as? String
            var birthday = allResults["birthday"] as? String
            
            let birthdayComp: Date = self.fetchFormatter.date(from: birthday!)!
            let ageComponents = Calendar.current.dateComponents([.year], from: birthdayComp, to: Date())
            let age = ageComponents.year!
            
            DBProvider.Instance.saveUser(name: name!, birthday: &birthday, gender: gender!, email: &email, fbid: id!)
            FacebookUser.Instance.set(userName: name!, userAge: age, userGender: gender!, userID: id!)
//            
//            if email != nil {
//                Crashlytics.sharedInstance().setUserEmail(email)
//            }
//            Crashlytics.sharedInstance().setUserIdentifier(id)
//            Crashlytics.sharedInstance().setUserName(name)
//            
            loginHandler?(nil)
            
        }
        
    }
    
    
    
    func logout() -> Bool {
        
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                return true
            }
            catch {
                return false
            }
        }
        return true
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        if let error = FIRAuthErrorCode(rawValue: err.code) { // converting error into a
            print("Handle errors in AuthProvider: \(error)")
            //firebase error to know what is wrong
            // handle errors with FIR Sign in
        }
    }
    
    
    
}
