//
//  ViewController.swift
//  iBeaconSample
//
//  Created by PIVOT on 2016. 4. 21..
//  Copyright © 2016년 PIVOT. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    // UUID는 iBeacon Emitter마다 다름.
    let UUID = NSUUID(UUIDString: "A2FA7357-C8CD-4B95-98FD-9D091CE43337")
    let identifier = "TestBeaconIdentifier"

    var beaconRegion: CLBeaconRegion!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notification Permission
        let notificationSettings = UIUserNotificationSettings(forTypes:[.Alert, .Sound] , categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)

        // Location Permission
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    
        beaconRegion = CLBeaconRegion(proximityUUID: UUID!, identifier: identifier)
        beaconRegion.notifyOnExit = true
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyEntryStateOnDisplay = false
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        sendNotification("Enter Region")
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        sendNotification("Exit Region")
        locationManager.stopRangingBeaconsInRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationManager.startMonitoringForRegion(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if let beacon = beacons.first {
            print ("Beacon Info - UUID:\(beacon.proximityUUID.UUIDString) MAJOR:\(beacon.major) MINOR:\(beacon.minor) ACCURACY:\(beacon.accuracy)")
            NSLog("Beacon accuracy : %lf", beacon.accuracy)
        }
    }
    
    
    // MARK: - Notification
    func sendNotification(message: String) {
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.fireDate = NSDate()
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }


}

