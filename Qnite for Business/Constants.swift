//
//  Constants.swift
//  Qnight
//
//  Created by Francesco Virga on 2017-06-19.
//  Copyright © 2017 David Choi. All rights reserved.
//

import Foundation


// database keys

struct FIR_EVENT_DATA {
    static let USERS_ATTENDING = "users_attending"
    static let COVER_ID = "serial"
    static let FEEDBACK = "feedback"
    static let DID_SCAN = "scanned"
}

struct FIR_EVENT_INFO {
    static let EVENT = "event"
    static let NAME = "name"
    static let DESCRIPTION = "description"
    static let LOCATION = "location"
    static let START_TIME = "start_time"
    static let END_TIME = "end_time"
}

struct FIR_VENUE_INFO {
    static let NAME = "name"
    static let ADDRESS = "address"
    static let COORDINATES = "coordinates"
    static let COORDINATES_LAT = "latitude"
    static let COORDINATES_LONG = "longitude"
}

struct LISTENER_NAME {
    static let LOCATION = NSNotification.Name("LocationNotification")
    static let PAYMENT_COVER = NSNotification.Name("PaymentCoverNotification")
    static let PAGE_LOADING_COMPLETE = NSNotification.Name("LoadingComplete")
    static let COVER_PAGE_ID = NSNotification.Name("CoverPageId")
    
    static let TOKEN_AUTHORIZED = NSNotification.Name("TokenAuthorized")
}


struct NOTIFICATION_ID {
    static let CATEGORY_POST_EVENT = "POST_EVENT"
    static let ACTION_GOOD = "GOOD_ACTION"
    static let ACTION_BAD = "BAD_ACTION"
    static let ACTION_NO_ATTENDANCE = "NO_ATTENDANCE_ACTION"
    
    static let CATEGORY_ATTENDING_EVENT = "ATTENDING_EVENT"
    static let ACTION_NOT_GOING = "NOT_GOING_ACTION"
    static let ACTION_BUY_COVER = "BUY_COVER_ACTION"
}

struct NOTIFICATION_TEXT {
    static let POST_EVENT_GOOD = "Super lit! 😁"
    static let POST_EVENT_BAD = "Not fun 😔"
    static let POST_EVENT_NO_ATTENDANCE = "Didn't make it 🤥"
    
    static let ATTENDING_EVENT_BUY_COVER = "OK"
    static let ATTENDING_EVENT_NOT_GOING = "Not going there tn 😒"
}

// put in FIR
let MERCHANT_ID = "merchant.com.francescovirga.Qnight"
let FB_USER_FETCH_PARAMS = "id,name,email,gender,birthday"

let DATE_FORMATTER_HOUR: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    return formatter
}()

let DATE_FORMATTER_DB: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter
}()

class Constants {
    private static let _instance = Constants()
    static var Instance: Constants {
        return _instance
    }
    
    func getDateInDBFormat() -> String {
        return DATE_FORMATTER_DB.string(from: Date())
    }
    
}
