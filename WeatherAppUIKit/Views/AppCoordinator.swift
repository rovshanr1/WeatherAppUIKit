//
//  ViewController.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 16.09.25.
//

import UIKit
import CoreLocation

final class AppCoordinator{
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
 
    func start(){
        let welcomeViewController = WelcomeViewController()

        welcomeViewController.onLocationSelected = { [weak self] coordinate in
        guard let self = self else { return }
            self.showWeather(for: coordinate)
        }
        
        navigationController.viewControllers = [welcomeViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
    private func showWeather(for coordinate: CLLocationCoordinate2D){
        let weatherVC = WeatherViewController(coordinate: coordinate)
        navigationController.pushViewController(weatherVC, animated: true)
    }
}

