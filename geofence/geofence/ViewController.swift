//
//  ViewController.swift
//  geofence
//
//  Created by Zachary Browne on 3/16/16.
//  Copyright © 2016 zbrowne. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0
        locationManager.pausesLocationUpdatesAutomatically = true
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        let coord = CLLocationCoordinate2DMake(37.7833, -122.4167)
        let radius = 100
        
        Geofence.init(coordinate: coord, radius: 100, identifier: "San Francisco", note: "Testing Location", eventType: EventType.OnEntry)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func regionWithGeofence(geofence: Geofence) -> CLCircularRegion {
        let region = CLCircularRegion(center: geofence.coordinate, radius: geofence.radius, identifier: geofence.identifier)
        region.notifyOnEntry = (geofence.eventType == .OnEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoringGeofence(geofence: Geofence) {
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
            return
        }
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self)
        }
        let region = regionWithGeofence(geofence)
        locationManager.startMonitoringForRegion(region)
    }
}

