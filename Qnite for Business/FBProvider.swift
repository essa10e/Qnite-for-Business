//
//  FBProvider.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-28.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FBProvider {
    private static let _instance = FBProvider()
    static var Instance: FBProvider{
        return _instance
    }
    
    func graphRequest(pageID: String, fetchParameters: String, FBHandler: @escaping FBSDKGraphRequestHandler) {
        FBSDKGraphRequest(graphPath: pageID, parameters: ["fields": fetchParameters]).start(completionHandler: FBHandler)
    }
}




