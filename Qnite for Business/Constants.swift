//
//  Constants.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-07-10.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import Foundation

let DATE_FORMAT = "yyyy/MM/dd"

class Constants {
    private static let _instance = Constants()
    static var Instance: Constants {
        return _instance
    }
    
    let dateFormat = DateFormatter()
    
    func getFIRDateInFormat() -> String {
        dateFormat.dateFormat = DATE_FORMAT
        return dateFormat.string(from: Date())
    }
}
