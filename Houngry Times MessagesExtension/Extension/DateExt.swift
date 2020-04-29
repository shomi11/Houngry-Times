//
//  DateExt.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/29/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import Foundation


extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        return dateFormatter.string(from: self)
    }
}
