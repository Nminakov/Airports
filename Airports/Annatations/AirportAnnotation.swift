//
//  AirportAnnotation.swift
//  Airports
//
//  Created by Никита on 04/10/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation
import MapKit

class AirportAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var name: String
    var imadge: UIImage
    
    init(coordinate: CLLocationCoordinate2D, name: String = "", image: UIImage = UIImage()) {
        self.coordinate = coordinate
        self.name = name
        self.imadge = image
    }
    
}
