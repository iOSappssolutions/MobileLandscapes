//
//  LocationHandler.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 19/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    private var locationManager = CLLocationManager()
    private var previousLocation: CLLocation?
    var locationUpdatedCallback: ((Double, Double)->())?
    
    override init() {
        
        super.init()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true;
        }
        locationManager.distanceFilter = 100

    }
  
    func authorizeLocationService() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation()-> Bool {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus != .authorizedAlways && authorizationStatus != .authorizedWhenInUse) {
          return false
        }
  
        locationManager.startUpdatingLocation()
        return true
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /** we could use altitude attribute here if we were to take it in calculation but then it would make sense to lower distance filter to get more precise meassurment
         my implementation was considering level of accuracy needed for this kind of app, changing to take distance traveled with altitude change taken in account wouldn't be complicated either
         I just left it the way it is when all things conaisdering everything **/
        guard let currentLocation = locations.last, let locationUpdatedCallback = locationUpdatedCallback else { return }
        NSLog("Current Location lat = %@, lon = %@", String(currentLocation.coordinate.latitude), String(currentLocation.coordinate.longitude))
        if let pl = previousLocation {
            NSLog("Previous Location lat = %@, lon = %@", String(pl.coordinate.latitude), String(pl.coordinate.longitude))
            let distance = currentLocation.distance(from: pl)
            NSLog("Distance between previous and current = %@", String(distance))
            if distance >= 100 {
                locationUpdatedCallback(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            }
        } else {
            // if it's furst run search for first picture wherever you are
            NSLog("First location update, searching for photo anyway...")
            locationUpdatedCallback(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        }
        previousLocation = currentLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error locating: \(error.localizedDescription)")
    }
  
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
          NSLog("pauseeee")
    }
  
}
