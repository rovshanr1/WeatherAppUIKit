//
//  ForecastCollectionViewCell.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 24.09.25.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            
            timeLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            

        ])
    }
    
    func configure(with forecastItem: ForecastModel.List){
        temperatureLabel.text = "\(forecastItem.main.temp.rounded())°C"
        timeLabel.text = forecastItem.hourPM

        let iconCode = forecastItem.weather.first?.icon
        let iconName = iconCode?.weatherIcon() ?? "sun.max.fill"
        iconImageView.image = UIImage(systemName: iconName)
    }
}
