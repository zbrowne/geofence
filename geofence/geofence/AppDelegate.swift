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

enum UserState {
    case OnTrain
    case OffTrainAtStation
    case Away
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    static func sharedInstance() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var stationRegion = CLCircularRegion()
    var currentUserState = UserState.Away
    var userStateArray = [UserState]()
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
        if let region = region as? CLCircularRegion {
            stationRegion = region
            NSLog("Entered Region")
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            NSLog("Exited Region")
            locationManager.stopUpdatingLocation()
            userStateArray.removeAll()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            
            if location.horizontalAccuracy < 65 {
                
                // user is in region and on train
                if stationRegion.containsCoordinate(location.coordinate) && isUserOnTrain(stations[0], location: location) {
                    currentUserState = UserState.OnTrain
                }
                    // user is in region and off train
                else if stationRegion.containsCoordinate(location.coordinate) && !isUserOnTrain(stations[0], location: location) {
                    currentUserState = UserState.OffTrainAtStation
                }
                    // default state away from station
                else {currentUserState = UserState.Away}
                NSLog(String(currentUserState))
                
                // append most recent user state to user state array
                userStateArray.append(currentUserState)
                NSLog(String(userStateArray))
                
                // TESTING ONLY: call method in ViewController that updates text label to display current user state
                let nav = window?.rootViewController as? UINavigationController
                let vc = nav?.visibleViewController as! ViewController
                vc.updateUserState(currentUserState)
                
                // check for a state change that requires a "Tag Off" notification
                checkForTagOffStateChange()
            }
        }
    }
    
    func isUserOnTrain(station: Station, location: CLLocation) -> Bool {
        
        // station platform
        let platformPolygon: CGMutablePathRef = CGPathCreateMutable()
        var latestUserLocation = CGPoint()
        for points in station.platform {
            if points == station.platform.first! {
                CGPathMoveToPoint(platformPolygon, nil, CGFloat(points.0), CGFloat(points.1))
            }
            else {
                CGPathAddLineToPoint(platformPolygon, nil, CGFloat(points.0), CGFloat(points.1))
            }
        }
        
        // latest reported GPS location of user
        latestUserLocation = CGPointMake(CGFloat(location.coordinate.latitude), CGFloat(location.coordinate.longitude))
        
        // check to see if latest reported GPS location of user is in the station platform
        let pointIsInPolygon: Bool = CGPathContainsPoint(platformPolygon, nil, latestUserLocation, false)
        return pointIsInPolygon
    }
    
    // delivers a "Tag Off" notification when a user changes from a "OnTrain" state to a "OffTrainAtStation" state
    func checkForTagOffStateChange() {
        if userStateArray.last == UserState.OffTrainAtStation && userStateArray[userStateArray.count - 2] == UserState.OnTrain {
            let notification = UILocalNotification()
            notification.alertBody = "Tag Off"
            notification.soundName = "Default"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            NSLog("Tag Off notification triggered")
        }
    }
}

