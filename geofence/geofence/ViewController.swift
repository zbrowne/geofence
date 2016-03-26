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
    @IBOutlet weak var userState: UILabel!
    
    let locationManager = CLLocationManager()
    let stations = Caltrain.sharedInstance().stations
    let region = MKCoordinateRegion(center: Caltrain.sharedInstance().stations[0].coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    let radius = 100.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = true
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        
        for station in stations {
        let stationGeofence = Geofence(coordinate: station.coord, radius: radius, identifier: station.name, note: station.address)
        startMonitoringGeofence(stationGeofence)
        addRadiusOverlayForGeofence(stationGeofence)
        addPlatformBoundary(station)
        setRegion(region, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // functions for region monitoring
    
    func regionWithGeofence(geofence: Geofence) -> CLCircularRegion {
        let region = CLCircularRegion(center: geofence.coordinate, radius: geofence.radius, identifier: geofence.identifier)
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
    
    // functions for mapview
    
    func addRadiusOverlayForGeofence(geofence: Geofence) {
        mapView.addOverlay(MKCircle(centerCoordinate: geofence.coordinate, radius: geofence.radius))
    }
    
    func addPlatformBoundary(station: Station) {
        var stationPolygon: MKPolygon
        var coords = station.platform.map { CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1) }
        stationPolygon = MKPolygon(coordinates: &coords, count: coords.count)
        mapView.addOverlay(stationPolygon)
    }
    
    func setRegion(region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = UIColor.purpleColor()
            circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
            return circleRenderer
        }
        if let overlay = overlay as? MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.magentaColor()
            polygonView.fillColor = UIColor.magentaColor()
            return polygonView
        }
        return MKPolylineRenderer()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    // update text label on map to display current user state
    func updateUserState(state: UserState) {
        userState?.text = String(state)
    }
    
    // error handling
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
        NSLog(String(error))
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Location Manager failed with the following error: \(error)")
    }
    
}

