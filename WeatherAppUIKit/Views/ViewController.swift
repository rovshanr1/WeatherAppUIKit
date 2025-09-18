//
//  ViewController.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 16.09.25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }

    private func setupUI() {
       setupBackground()
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
            backgrounImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}

