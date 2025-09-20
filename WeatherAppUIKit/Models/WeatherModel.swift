//
//  WeatherModel.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 18.09.25.
//

import Foundation

struct WeatherModel: Codable{
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let id: Int
    let name: String
    let dt: Int
    let cod: Int
    let sys: Sys
    
    
    var formatedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        return Self.dateFormatter.string(from: date)
    }
    
    struct Coord: Codable {
        let lon, lat: Double
    }
    
    struct Sys: Codable {
        let country: String
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int?
        let humidity: Int?
        
        var tempString: String {
            "\(Int(temp))"
        }
        
        var tempMaxString: String {
            "\(Int(tempMax))"
        }
        
        var tempMinString: String {
            "\(Int(tempMin))"
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
}


extension WeatherModel {
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.timeStyle = .short
        return formatter
    }
}
