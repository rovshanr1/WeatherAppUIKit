//
//  WeatherViewController.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 21.09.25.
//

import UIKit
import CoreLocation
import Combine

class WeatherViewController: UIViewController {
    let coordinate: CLLocationCoordinate2D
    
    private var cancellable = Set<AnyCancellable>()
    private let weatherManager = WeatherManager()
    
    private var weatherModel: WeatherModel?
    private var forecastModel: ForecastModel?
    
    let reusableIdentifier: String = "ForecastCollectionViewCell"
    
    private var dateLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    private var cityName: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var temperature: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 86, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var weatherDegree: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tempMax: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tempMin: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView  = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let regtangle: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.hidesBackButton = true
        setupBackground()
        fetchWeather()
        fetchForecast()
        
        weatherCollection.translatesAutoresizingMaskIntoConstraints = false
        weatherCollection.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        weatherCollection.dataSource = self
        weatherCollection.delegate = self
        
        view.addSubview(dateLabel)
        view.addSubview(cityName)
        view.addSubview(temperature)
        view.addSubview(weatherDegree)
        view.addSubview(tempMax)
        view.addSubview(tempMin)
        view.addSubview(regtangle)
        view.addSubview(conditionLabel)
        view.addSubview(weatherCollection)
        
       
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            cityName.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6),
            cityName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            temperature.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 34),
            temperature.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            weatherDegree.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 52),
            weatherDegree.leadingAnchor.constraint(equalTo: temperature.trailingAnchor, constant: 12),
            
            tempMax.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tempMax.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 12),

            tempMin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tempMin.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 58),
            
            regtangle.topAnchor.constraint(equalTo: temperature.bottomAnchor, constant: 8),
            regtangle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            regtangle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            regtangle.heightAnchor.constraint(equalToConstant: 2),
            
            conditionLabel.topAnchor.constraint(equalTo: regtangle.bottomAnchor, constant: 12),
            conditionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            conditionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            weatherCollection.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 12),
            weatherCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            weatherCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            weatherCollection.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func updateWeather(with weather: WeatherModel){
        dateLabel.text = weather.formatedDate
        cityName.text = weather.name
        temperature.text = weather.main.tempString
        weatherDegree.text = "°C"
        tempMax.text = "↑\(weather.main.tempMaxString)°C"
        tempMin.text = "↓\(weather.main.tempMinString)°C"
        conditionLabel.text = "\(weather.weather.first?.description ?? "No description")".uppercased()
    }
    
    private func updateForecast(with forecast: ForecastModel) {
        self.forecastModel = forecast
        
        DispatchQueue.main.async {
            self.weatherCollection.reloadData()
        }
    }
    
    private func setupBackground(){
        view.backgroundColor = .white
        let backgrounImageView = UIImageView()
        backgrounImageView.image = UIImage(named: "BackgroundGlow1")
        backgrounImageView.contentMode = .scaleAspectFill
        backgrounImageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgrounImageView, at: 0)
        
        NSLayoutConstraint.activate([
            backgrounImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgrounImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgrounImageView.heightAnchor.constraint(equalToConstant: 540),
            
            
        ])
    }
}

//MARK: - Fetching Data
extension WeatherViewController{
    private func fetchWeather(){
        weatherManager.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            .sink(receiveCompletion: {completion in
                print(completion)
            }, receiveValue: {[weak self] weather in
                guard let self = self else { return }
                self.weatherModel = weather
                DispatchQueue.main.async {
                    self.updateWeather(with: weather)
                }
            })
            .store(in: &cancellable)
    }
    
    private func fetchForecast(){
        weatherManager.fetchForecast(latitude: coordinate.latitude, longitude: coordinate.longitude)
            .sink(receiveCompletion: {completion in
                print(completion)
            }, receiveValue: {[weak self] forecast in
                guard let self = self else { return }
                self.updateForecast(with: forecast)
            })
            .store(in: &cancellable)
    }
}

//MARK: - CollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastModel?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! ForecastCollectionViewCell
        
        if let forecastItem = forecastModel?.list[indexPath.item]{
            cell.configure(with: forecastItem)
        }
        
        return cell
    }
}


//MARK: - CollectionViewDelegateFlowLayout
extension WeatherViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 74)
    }
}
