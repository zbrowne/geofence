//
//  Geofence.swift
//  geofence
//
//  Created by Zachary Browne on 3/17/16.
//  Copyright © 2016 zbrowne. All rights reserved.
//

import Foundation
import CoreLocation

class Geofence {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var note: String
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.note = note
    }
}
