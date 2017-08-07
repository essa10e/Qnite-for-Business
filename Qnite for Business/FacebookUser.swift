//
//  FacebookUser.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-08-05.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import Foundation

class FacebookUser {
    private static let _instance = FacebookUser()
    static var Instance: FacebookUser {
        return _instance
    }
    
    var name: String?
    var age: Int?
    var gender: String?
    var id: String?
    var pageName: String?
    var pageId: String?
    
    func set(userName: String, userAge: Int, userGender: String, userID: String) {
        self.name = userName
        self.age = userAge
        self.gender = userGender
        self.id = userID
    }
    
    func tokenAuthorized(pageName: String, pageId: String) {
        self.pageName = pageName
        self.pageId = pageId
    }
}
