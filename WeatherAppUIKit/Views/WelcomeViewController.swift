//
//  WelcomeViewController.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 21.09.25.
//

import UIKit
import CoreLocation
import Combine


class WelcomeViewController: UIViewController {
    
    //to go to WelcomeVC callback closure 
    var onLocationSelected: ((CLLocationCoordinate2D) -> Void)?
    
    //Stored Properties
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    
    
    private var welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the Weather App"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var footNoteText: UILabel = {
        let label = UILabel()
        label.text = "Please share yout current location to get weather in your area"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textColor = .white.withAlphaComponent(0.75)
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.setTitle( " Share Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        locationManager.$location
            .compactMap { $0 }
            .first()
            .sink { [weak self] location in
                guard let self = self else { return }
                self.locationButton.isHidden = false
                self.loadingIndicator.stopAnimating()
                self.onLocationSelected?(location)
            }
            .store(in: &cancellables)
    }
    
    //after the setupui() is set, the button that will be called will appear
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        locationButton.layer.cornerRadius = locationButton.frame.height / 2
        locationButton.clipsToBounds = true
    }

    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.13,green: 0.12,blue: 0.31, alpha: 1.0)
        
        // adding subview
        view.addSubview(welcomeText)
        view.addSubview(footNoteText)
        view.addSubview(locationButton)
        view.addSubview(loadingIndicator)
        
        //location button animation and functionality])
        locationButton.addTarget(self, action: #selector(handleLocationButtonTapped), for: .touchUpInside)
        
        //constraints
        NSLayoutConstraint.activate([
            welcomeText.topAnchor.constraint(equalTo: view.topAnchor, constant: 330),
            welcomeText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            footNoteText.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 8),
            footNoteText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footNoteText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            footNoteText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            locationButton.topAnchor.constraint(equalTo: footNoteText.bottomAnchor, constant: 42),
            locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            locationButton.widthAnchor.constraint(equalToConstant: 200)
            
        ])
        
        
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: footNoteText.bottomAnchor, constant: 42),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //button actions
    @objc private func handleLocationButtonTapped() {
        self.loadingIndicator.startAnimating()
        self.locationButton.isHidden = true
        
        locationManager.startUpdatingLocation()
    }
}
