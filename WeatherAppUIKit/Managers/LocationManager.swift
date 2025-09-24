//
//  LocationManager.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 20.09.25.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, CLLocationManagerDelegate{
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var error: String?
    @Published var isLoading: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    
    func startUpdatingLocation() {
        manager.requestWhenInUseAuthorization()
        isLoading = true
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        self.location = location
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = LocationError.errorGettingLocation.localizedDescription
        isLoading = false
    }
}
