//
//  WeatherSearchViewController.swift
//  WeatherCucumber
//
//  Created by Kenneth Poon on 21/3/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation
import UIKit
class WeatherSearchViewController: UIViewController {
 
    //@IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet var defaultStateView: UIView!    
    
    @IBOutlet weak var noLocationLabel: UILabel!
    private var weatherResult: [WeatherResultItem]? = nil  
    private let cellIdentifier = "Cell" 
    
    let weatherApiSearchService = WeatherApiSearchService()
    
    init(){
        super.init(nibName: "WeatherSearch", bundle: Bundle(for: WeatherSearchViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "WeatherSearchView"
        
        self.tableView.register(WeatherCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.backgroundView = self.defaultStateView
        self.tableView.separatorInset = .zero
        self.tableView.layoutMargins = .zero
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.searchBar.delegate = self
        self.searchBar.accessibilityLabel = "SearchField"
        self.searchBar.returnKeyType = .done
        view.setNeedsLayout()  
        view.layoutIfNeeded() 
    }
}

extension WeatherSearchViewController: UITableViewDataSource {  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = self.weatherResult, result.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
            return result.count
        }
        tableView.separatorStyle = .none
        tableView.backgroundView?.isHidden = false

        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        
    
        if let aWeatherResult = self.weatherResult{
            
            let weatherResultItem = aWeatherResult[indexPath.row]
            
            cell.textLabel?.text = weatherResultItem.locationName
            cell.detailTextLabel?.text = weatherResultItem.country
        }
        
        return cell
    }
}

extension WeatherSearchViewController: UITableViewDelegate {
    
    //WeatherDetailViewController
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let aWeatherResult = self.weatherResult{
            let weatherResultItem = aWeatherResult[indexPath.row]
            self.navigationController?.pushViewController(WeatherDetailViewController(weatherResultItem: weatherResultItem), animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension WeatherSearchViewController: UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard searchText.characters.count > 0 else {
            self.weatherResult = nil
            self.tableView.backgroundView = self.defaultStateView
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            return
        }
        
        weatherApiSearchService.fetchLocations(query: searchText, completion: { [weak self] receivedWeather in
            
            self?.weatherResult = receivedWeather
            DispatchQueue.main.async {
                self?.tableView.backgroundView = self?.emptyStateView
                self?.tableView.reloadData()
            }
            

        }, errorHandler: {
            
            self.weatherResult = nil
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        })
    }
        
}

class WeatherCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

