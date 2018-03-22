//
//  WeatherApiSearchService.swift
//  WeatherCucumber
//
//  Created by Kenneth Poon on 21/3/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

class WeatherApiSearchService {
    
    var locationDataTask: URLSessionDataTask? = nil
    
    func fetchLocations(query: String, completion: @escaping (([WeatherResultItem])->Void), errorHandler: @escaping (()->Void)){
        //let urlString = URL(string: "https://api.apixu.com/v1/current.json?key=8508bd015b1d4b16b1a171921182003&q=\(query)")
        
        let urlString = URL(string: "https://api.worldweatheronline.com/premium/v1/search.ashx?query=\(query)&num_of_results=3&format=json&key=ba558f8ebb9e44d6b4d171555182003")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    errorHandler()
                    return
                }
                do {
                    let json:AnyObject =  (try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary)!                        
                    print(json)
                    
                    var items = [WeatherResultItem]()
                    if let dataJson = json["data"] as? [String: Any], 
                        let errorJsonArray = dataJson["error"] as? [[String: Any]],
                        let errorJson = errorJsonArray.first,
                        let msg = errorJson["msg"] as? String,
                        msg == "Unable to find any matching weather location to the query submitted!"{
                        completion(items)
                        return
                    }
                    
                    guard let searchApiJson = json["search_api"] as? [String: Any],
                        let resultArray = searchApiJson["result"] as? [[String: Any]] else {
                            completion(items)
                            return 
                    }
                    for resultJson in resultArray {
                        guard let areaNameArray = resultJson["areaName"] as? [[String: Any]],
                            let areaNameObject = areaNameArray.first,
                            let locationName = areaNameObject["value"] as? String,
                            
                            let regionJsonArray = resultJson["region"] as? [[String: Any]],
                            let regionObject = regionJsonArray.first,
                            let region = regionObject["value"] as? String,
                            
                            let countryJsonArray = resultJson["country"] as? [[String: Any]],
                            let countryObject = countryJsonArray.first,
                            let country = countryObject["value"] as? String,
                            
                            let latitude = resultJson["latitude"] as? String,
                            let longitude = resultJson["longitude"] as? String else {
                            continue    
                        }
                        let item = WeatherResultItem(locationName: locationName, region: region, country: country, latitude: latitude, longitude: longitude)
                        items.append(item)                        
                    }
                    completion(items)
                    
                    
                    
                } catch _ as NSError {
                    // error handling
                    errorHandler()
                }
            }
            locationDataTask?.cancel()
            locationDataTask = task
            locationDataTask?.resume()
        }
    }
}
