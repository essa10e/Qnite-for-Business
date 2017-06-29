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
    
    func login(loginHandler: LoginHandler?) { // need to handle when user declines permissions
        
        
        let accessToken =  FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            loginHandler?("You need to login to Facebook to use Qnight")
            return
        }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
            }
            else {
                loginHandler?(nil)
            }
        })
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
