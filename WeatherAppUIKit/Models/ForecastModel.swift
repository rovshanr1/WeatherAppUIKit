//
//  ForecastModel.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 18.09.25.
//

import Foundation

struct ForecastModel: Codable{
    let cod: String
    let message, cnt: Int
    let lits: [List]
    let city: City
    
    
    struct City: Codable{
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population, timezone, sunrise, sunset: Int
    }
    
    struct Coord: Codable{
        let lon, lat: Double
    }
    
    struct List: Codable, Identifiable{
        let dt: Int
        let main: MainClass
        let weather: [Weather]
        let dtTxt: String
        
        var id: Int {dt}
        
        var hourPM: String{
            if let date = Self.inputFormatter.date(from: dtTxt){
                return Self.amPmFormatter.string(from: date)
            }
            return " "
        }
    }
    
    struct MainClass: Codable{
        let temp: Double
        
        var tempInt: Int {Int(temp)}
    }
    
    struct Weather: Codable{
        let id: Int
        let icon: String
    }
}

extension ForecastModel.List{
    private static var inputFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    private static var amPmFormatter: DateFormatter{
        let amPmFormatter = DateFormatter()
        amPmFormatter.locale = Locale(identifier: "en_US_POSIX")
        amPmFormatter.dateFormat = "h a"
        return amPmFormatter
    }
}
