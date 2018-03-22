//
//  WeatherDetailViewController.swift
//  WeatherCucumber
//
//  Created by Kenneth Poon on 22/3/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation
import UIKit
class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let weatherResultItem: WeatherResultItem
    let weatherApiDetailService = WeatherApiDetailService()
    
    init(weatherResultItem: WeatherResultItem){
        self.weatherResultItem = weatherResultItem
        super.init(nibName: "WeatherDetailView", bundle: Bundle(for: WeatherSearchViewController.self))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.weatherResultItem = WeatherResultItem(locationName: "", region: "", country: "", latitude: "", longitude: "")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "WeatherDetailView"
        self.mainView.isHidden = true
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        
        self.locationLabel.text = self.weatherResultItem.locationName
        self.countryLabel.text = self.weatherResultItem.country
        
        self.weatherApiDetailService.fetchDetail(resultItem: self.weatherResultItem, completion: { [weak self] resultDetail in
            
            DispatchQueue.main.async { 
                self?.temperatureLabel.text = "\(resultDetail.temperatureCelsius)C"
                self?.descriptionLabel.text = resultDetail.weatherDescription
                self?.mainView.isHidden = false
                self?.activityIndicatorView.isHidden = true
                self?.activityIndicatorView.stopAnimating()
            }
            
            
        }, errorHandler: {
                    
        })
        
        
    }
}
