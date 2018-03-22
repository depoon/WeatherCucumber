//
//  WeatherApiDetailService.swift
//  WeatherCucumber
//
//  Created by Kenneth Poon on 22/3/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

class WeatherApiDetailService {
    
    var dataTask: URLSessionDataTask? = nil
    
    func fetchDetail(resultItem: WeatherResultItem, completion: @escaping ((WeatherDetail)->Void), errorHandler: @escaping (()->Void)){        
        
        let urlString = URL(string: "https://api.worldweatheronline.com/premium/v1/weather.ashx?key=ba558f8ebb9e44d6b4d171555182003&q=\(resultItem.latitude),\(resultItem.longitude)&format=json")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    errorHandler()
                    return
                }
                do {
                    let json:AnyObject =  (try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary)!                        
                    print(json)                    
                    
                    guard let dataJson = json["data"] as? [String: Any],
                        let currentConditionArray = dataJson["current_condition"] as? [[String: Any]],
                        let conditionObject = currentConditionArray.first,
                        let temperatureCelsius = conditionObject["temp_C"] as? String,
                        let weatherDescriptionArray = conditionObject["weatherDesc"] as? [[String: Any]],
                        let descriptionObject = weatherDescriptionArray.first,
                        let weatherDescription = descriptionObject["value"] as? String else {
                            errorHandler()
                            return 
                    }
                    let detail = WeatherDetail(locationName: resultItem.locationName, country: resultItem.country, temperatureCelsius: temperatureCelsius, weatherDescription: weatherDescription)
                    completion(detail)
                    
                } catch _ as NSError {
                    // error handling
                    errorHandler()
                }
            }
            dataTask?.cancel()
            dataTask = task
            dataTask?.resume()
        }
    }
}
