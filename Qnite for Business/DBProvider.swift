//
//  DBProvider.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-27.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider()
    static var Instance: DBProvider{
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return dbRef.child("Users")
    }
    
    var eventRef: FIRDatabaseReference {
        return dbRef.child("Event Stats")
    }
    
    var eventRequestRef: FIRDatabaseReference {
        return dbRef.child("Event Request")
    }
    
    var venueInfoRef: FIRDatabaseReference {
        return dbRef.child("Venue Info")
    }
    
}
