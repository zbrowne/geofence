//
//  Stations.swift
//  geofence
//
//  Created by Zachary Browne on 3/20/16.
//  Copyright © 2016 zbrowne. All rights reserved.
//

import Foundation
import MapKit

struct Caltrain {
    private static let caltrain = Caltrain()
    static func sharedInstance() -> Caltrain {
        return caltrain
    }
    
    let stations: [Station] = [
        Station(
            name: "Borderlands Cafe",
            address: "866 Valencia Street, San Francisco, 94110",
            zone: 0,
            center: (37.758986, -122.421330),
            platform: [
                (37.760054, -122.421502),
                (37.756936, -122.421185),
                (37.756945, -122.421078),
                (37.760062, -122.421384)
            ])
        
        /*Station(name: "San Francisco", address: "700 4th St., San Francisco 94107", lat: 37.775874, long: -122.395556, zone: 1),
        Station(name: "22nd Street", address: "1149 22nd St., San Francisco 94107", lat: 37.757247, long: -122.392363, zone: 1),
        Station(name: "Bayshore", address: "400 Tunnel Ave., San Francisco 94134 ", lat: 37.707666, long: -122.401758, zone: 1),
        Station(name: "South San Francisco", address: "590 Dubuque Ave., South San Francisco 94080", lat: 37.655734, long: -122.40502, zone: 1),
        Station(name: "San Bruno", address: "833  San Mateo Ave., San Bruno 94066", lat: 37.630189, long: -122.411492, zone: 1),
        Station(name: "Millbrae Transit Center", address: "100 California Drive, Millbrae 94030", lat: 37.600399, long: -122.387014, zone: 2),
        Station(name: "Broadway (Weekend only)", address: "1190 California Drive, Burlingame 94010", lat: 37.587274, long: -122.361969, zone: 2),
        Station(name: "Burlingame", address: "290 California Drive, Burlingame 94010", lat: 37.579765, long: -122.34406, zone: 2),
        Station(name: "San Mateo", address: "385 First Ave., San Mateo 94401", lat: 37.568324, long: -122.324115, zone: 2),
        Station(name: "Hayward Park", address: "401 Concar Drive, San Mateo 94402", lat: 37.553163, long: -122.309562, zone: 2),
        Station(name: "Hillsdale", address: "3333 El Camino Real, San Mateo 94403", lat: 37.538427, long: -122.297905, zone: 2),
        Station(name: "Belmont", address: "995 El Camino Real, Belmont 94402", lat: 37.538448, long: -122.297919, zone: 2),
        Station(name: "San Carlos", address: "599 El Camino Real, San Carlos 94070", lat: 37.508041, long: -122.260235, zone: 2),
        Station(name: "Redwood City", address: "1 James Ave., Redwood City, Ca. 94063", lat: 37.485791, long: -122.23143, zone: 2),
        Station(name: "Atherton (Weekend only)", address: "1 Dinkelspiel Station Lane, Atherton 94027", lat: 37.46421, long: -122.197253, zone: 3),
        Station(name: "Menlo Park", address: "1120 Merrill St., Menlo Park 94025", lat: 37.454796, long: -122.182282, zone: 3),
        Station(name: "Palo Alto", address: "95 University Ave., Palo Alto 94301", lat: 37.443315, long: -122.164563, zone: 3),
        Station(name: "Stanford (Football only)", address: "100 Embarcadero Rd., Palo Alto 94301", lat: 37.438567, long: -122.156534, zone: 3),
        Station(name: "California Ave.", address: "101 California Ave., Palo Alto 94306", lat: 37.428813, long: -122.141112, zone: 3),
        Station(name: "San Antonio", address: "190 Showers Drive, Mountain View, 94040", lat: 37.407591, long: -122.10754, zone: 3),
        Station(name: "Mountain View", address: "600 W. Evelyn Ave., Mountain View 94041", lat: 37.394328, long: -122.075599, zone: 3),
        Station(name: "Sunnyvale", address: "121 W. Evelyn Ave., Sunnyvale 94086", lat: 37.378876, long: -122.031443, zone: 3),
        Station(name: "Lawrence", address: "137 San Zeno Way, Sunnyvale 94086", lat: 37.370561, long: -121.996967, zone: 4),
        Station(name: "Santa Clara", address: "1001 Railroad Ave., Santa Clara 95050", lat: 37.353121, long: -121.935512, zone: 4),
        Station(name: "College Park", address: "780 Stockton Ave., San Jose 95126", lat: 37.342887, long: -121.915691, zone: 4),
        Station(name: "San Jose Diridon", address: "65 Cahill St., San Jose 95110", lat: 37.329746, long: -121.903172, zone: 4),
        Station(name: "Tamien", address: "1355 Lick Ave., San Jose 95110", lat: 37.312449, long: -121.884588, zone: 4),
        Station(name: "Capitol", address: "3400 Monterey Hwy., San Jose 95111", lat: 37.284025, long: -121.841848, zone: 5),
        Station(name: "Blossom Hill", address: "5560 Monterey Hwy., San Jose 95138", lat: 37.252574, long: -121.79795, zone: 5),
        Station(name: "Morgan Hill", address: "17300 Depot St., Morgan Hill 95037", lat: 37.129769, long: -121.650738, zone: 6),
        Station(name: "San Martin", address: "13400 Monterey Hwy., San Martin 95046", lat: 37.085979, long: -121.610466, zone: 6),
        Station(name: "Gilroy", address: "7150 Monterey St., Gilroy 95020", lat: 37.004544, long: -121.566681, zone: 6),*/
    ]
}

struct Station {
    let name: String
    let address: String
    let coord: CLLocationCoordinate2D
    let zone: Int
    let platform: MKPolygon
    
    init(name: String, address: String, zone: Int, center: (CLLocationDegrees, CLLocationDegrees), platform: [(CLLocationDegrees, CLLocationDegrees)]) {
        self.name = name
        self.address = address
        self.zone = zone
        self.coord = CLLocationCoordinate2D(latitude: center.0, longitude: center.1)
        var coords = platform.map { CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1) }
        self.platform = MKPolygon(coordinates: &coords, count: coords.count)
    }
}


