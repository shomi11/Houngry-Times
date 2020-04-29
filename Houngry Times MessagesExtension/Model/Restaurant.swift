//
//  Restaurant.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/29/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import Foundation
import Messages

struct Restaurant {
    
    var name: String?
    var address: String?
    var phoneNumber: String?
    var resDate: Date?
    
    var isSet: Bool {
        return name != nil && address != nil && phoneNumber != nil && resDate == nil
    }
    
    var isFullSet: Bool {
        return name != nil && address != nil && phoneNumber != nil  && resDate != nil
    }

}


