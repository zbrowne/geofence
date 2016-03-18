//
//  ViewController.swift
//  geofence
//
//  Created by Zachary Browne on 3/16/16.
//  Copyright © 2016 zbrowne. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var geofenceDict = [String: Geofence]()
    let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(37.776687, -122.394867), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
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
        
        let coord = CLLocationCoordinate2DMake(37.776687, -122.394867) // coordinates for 4th and king station in SF
        let radius = 100.0
        
        let sfGeofence = Geofence(coordinate: coord, radius: radius, identifier: "San Francisco Station", note: "700 4th street, SF", eventType: EventType.OnEntry)
        startMonitoringGeofence(sfGeofence)
        geofenceDict[sfGeofence.identifier] = sfGeofence
        addRadiusOverlayForGeofence(sfGeofence)
        setRegion(region, animated: true)
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
        print ("monitoring for region")
    }
    
    func addRadiusOverlayForGeofence(geofence: Geofence) {
        mapView.addOverlay(MKCircle(centerCoordinate: geofence.coordinate, radius: geofence.radius))
    }
    
    func setRegion(region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = UIColor.purpleColor()
            circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
            return circleRenderer
        }
        return MKPolylineRenderer()
    }
    
}

