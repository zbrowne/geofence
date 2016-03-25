//
//  AppDelegate.swift
//  geofence
//
//  Created by Zachary Browne on 3/16/16.
//  Copyright © 2016 zbrowne. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    var locationArray = [CLLocationCoordinate2D]()
    let stations = Caltrain.sharedInstance().stations


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        locationManager.delegate = self
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            NSLog("Entered Region")
            locationManager.startUpdatingLocation()
            notifyUserWhenCrossingRegion()
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            NSLog("Exited Region")
            locationManager.stopUpdatingLocation()
            notifyUserWhenCrossingRegion()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
        print (location.coordinate)
        locationArray.append(location.coordinate)
        }
    }
    
    func isUserOnPlatform(station: Station) -> Bool {
        
        // station platform
        let platformPolygon: CGMutablePathRef = CGPathCreateMutable()
        var latestUserLocation = CGPoint()
        for points in station.platform {
            if (points == station.platform.first!) {
                CGPathMoveToPoint(platformPolygon, nil, CGFloat(points.0), CGFloat(points.1))
            }
            else {
                CGPathAddLineToPoint(platformPolygon, nil, CGFloat(points.0), CGFloat(points.1))
            }
        }
        
        // latest reported GPS location of user
        if let location = locationArray.last {
            latestUserLocation = CGPointMake(CGFloat(location.latitude), CGFloat(location.longitude))
            NSLog("latest user location is " + String(latestUserLocation))
            NSLog(String(locationArray.count))
        }
        
        // check to see if latest reported GPS location of user is in the station platform
        let pointIsInPolygon: Bool = CGPathContainsPoint(platformPolygon, nil, latestUserLocation, false)
        NSLog(String(pointIsInPolygon))
        return pointIsInPolygon
    }
    
    // testing function to see if my "check user location"
    func notifyUserWhenCrossingRegion() {
        for station in stations {
            if isUserOnPlatform(station) == true {
                let notification = UILocalNotification()
                notification.alertBody = "You are on the platform"
                notification.soundName = "Default"
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
            else {
                let notification = UILocalNotification()
                notification.alertBody = "You are NOT on the platform"
                notification.soundName = "Default"
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
        }
    }
}

