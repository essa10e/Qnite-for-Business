//
//  DataGenerator.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-27.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import Foundation

struct Sale {
    var month: String
    var value: Double
}

class DataGenerator {
    
    static var randomizedSale: Double {
        return Double(arc4random_uniform(10000) + 1) / 10
    }
    
    static func data() -> [Sale] {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var sales = [Sale]()
        
        for month in months {
            let sale = Sale(month: month, value: randomizedSale)
            sales.append(sale)
        }
        
        return sales
    }
}
