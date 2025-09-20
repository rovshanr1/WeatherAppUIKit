//
//  LocationError.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 20.09.25.
//

import Foundation

enum LocationError: LocalizedError {
    case denied
    case restricted
    case unavailable
    case errorGettingLocation
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .denied:
            return "Location access denied"
        case .restricted:
            return "Location access restricted"
        case .unavailable:
            return "Location unavailable"
        case .unknown(let error):
            return error.localizedDescription
        case .errorGettingLocation:
            return "Error getting location"
        }
    }
}

