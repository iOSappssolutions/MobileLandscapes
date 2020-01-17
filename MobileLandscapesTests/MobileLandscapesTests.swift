//
//  MobileLandscapesTests.swift
//  MobileLandscapesTests
//
//  Created by Miroslav Djukic on 18/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import XCTest
import CoreLocation

@testable import MobileLandscapes

class MobileLandscapesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocationUpdate() {
        let locationManager = MockLocationManager()
        var currentLocation = CLLocation(latitude: 45.2671, longitude: 19.8335)
        var previousLocation: CLLocation?
        locationManager.mockLocation = currentLocation
        let myLocationManager = LocationManager()
        
        myLocationManager.locationUpdatedCallback = { lat, lng in
             
            XCTAssert(currentLocation.coordinate.latitude == lat)
            XCTAssert(currentLocation.coordinate.longitude == lng)
            XCTAssert(previousLocation == nil || currentLocation.distance(from: previousLocation!) >= 100)

        }
        
        myLocationManager.locationManager(locationManager, didUpdateLocations: [currentLocation])
        
        previousLocation = currentLocation
        currentLocation = CLLocation(latitude: 45.2671, longitude: 19.835)
        locationManager.mockLocation = currentLocation
        myLocationManager.locationManager(locationManager, didUpdateLocations: [currentLocation])

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

fileprivate class MockLocationManager : CLLocationManager {
    var mockLocation: CLLocation?
    override var location: CLLocation? {
        return mockLocation
    }
    override init() {
        super.init()
    }
}
