//
//  WeatherManager.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 19.09.25.
//

import Foundation
import Combine
import CoreLocation

final class WeatherManager {
    let networkService: NetworkService
    let appiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    let baseURL = "https://api.openweathermap.org/data/2.5"
    
    init(networkService: NetworkService = BaseNetworkService()) {
        self.networkService = networkService
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> AnyPublisher<WeatherModel, Error> {
        do {
            let url = try fetchWeatherData(endpoint: "/weather", latitude: latitude, longitude: longitude)
            return networkService.fetchData(from: url)
        }catch{
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func fetchForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> AnyPublisher<ForecastModel, Error>{
        do{
            let url = try fetchWeatherData(endpoint: "/forecast", latitude: latitude, longitude: longitude)
            return networkService.fetchData(from: url)
        }catch{
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private func fetchWeatherData(endpoint: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) throws -> URL {
        guard var components = URLComponents(string: baseURL + endpoint) else {
            throw NetworkErrors.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: appiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components.url else{
            throw NetworkErrors.invalidURL
        }
        
        return url
    }
}
