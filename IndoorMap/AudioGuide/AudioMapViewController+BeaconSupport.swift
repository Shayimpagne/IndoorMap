//
//  AudioMapViewController+BeaconSupport.swift
//  IndoorMap
//
//  Created by Emir Shayymov on 28.05.2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit
import CoreLocation

extension AudioMapViewController {
    
    func resetBeacons() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        region = CLBeaconRegion.init(proximityUUID: uuid!, identifier: "museum_beacons")
        
        locationManager.stopMonitoring(for: region)
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case CLAuthorizationStatus.notDetermined:
            print("not authorized")
            break
        case CLAuthorizationStatus.authorized:
            print("authorized")
            break
        default:
            print("default value")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.locationManager.startRangingBeacons(in: self.region)
        print("entered")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.locationManager.stopRangingBeacons(in: self.region)
        print("exit")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            if beacon.proximity == .immediate {
                if let currentGuide = getGuideByID(id: Int(truncating: beacon.minor), in: guides) {
                    if lastRoom != currentGuide.id {
                        lastRoom = currentGuide.id
                        museumMap.changeUserLocation(x: currentGuide.location.0, y: currentGuide.location.1)
                        mapScroll.setContentOffset(CGPoint(x: currentGuide.location.0, y: currentGuide.location.1), animated: true)
                        playGuide(currentGuide: currentGuide)
                    }
                }
            }
        }
    }
    
    func meters(rssi: Int) -> Double {
        let txPower:Double = -59
        
        if (rssi == 0) {
            return -1.0
        }
        
        let ratio = (Double(rssi) * 1.0) / txPower
        
        if (ratio < 1.0) {
            return pow(ratio, 10)
        } else {
            let distance = (0.89976) * pow(ratio, 7.7095) + 0.111
            return distance
        }
        
    }
}
