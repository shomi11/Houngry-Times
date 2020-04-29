//
//  MapPin.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/27/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import Foundation
import MapKit


class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
        
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, name: String, phoneNumber: String, address: String) {
        self.coordinate = coordinate
        self.subtitle = phoneNumber
        self.title = name
        self.address = address
        super.init()
    }
}
