//
//  Geofence.swift
//  geofence
//
//  Created by Zachary Browne on 3/17/16.
//  Copyright © 2016 zbrowne. All rights reserved.
//

import Foundation
import CoreLocation

enum EventType: Int {
    case OnEntry = 0
    case OnExit
}

class Geofence {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var note: String
    var eventType: EventType
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.note = note
        self.eventType = eventType
    }
}
