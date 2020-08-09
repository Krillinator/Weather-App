//
//  ViewController.swift
//  WeatherAppFinal
//
//  Created by Kristoffer on 2020-08-03.
//  Copyright © 2020 Kristoffer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // OUTLETS
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet var uiBackground: UIView!
    @IBOutlet weak var realFeel: UILabel!
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var tempState: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animation INIT
        self.view.alpha = 0
        
        UIView.animate(withDuration: 1.5, animations: {
            self.view.alpha = 1.0
        })
        
        // Reload Data
        citiesTableView.reloadData()
        print(getCities())
        
        // Load Stockholm
        fetchWeatherData(cityName: "Gothenburg", completionHandler: changeWeather)
        
        // MARK: Gradient Background
        // Create a gradient layer.
        let gradientLayer = CAGradientLayer()

        // Layer = view frame
        gradientLayer.frame = view.bounds
        
        // Array - core graphics colors
        gradientLayer.colors = [#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).cgColor, UIColor(red: 250/255, green: 150/255, blue: 250/255, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true // Performance improvement
        
        // Flip gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        
        // Apply gradient to SUBLAYER
        uiBackground.layer.insertSublayer(gradientLayer, at: 0)
        
    }


    func changeWeather(weatherData: WeatherData) {
        // INIT
        let baseUrl = "https://openweathermap.org/img/wn/"
        let shortIconUrl = "@2x.png"
        let icon = weatherData.weather[0].icon
        let iconText = baseUrl + icon + shortIconUrl
        
        let iconUrl = URL(string: iconText)
        
        // Rounding temperature
        let x = weatherData.main.temp
        let rounded = (x*100).rounded()/100
        
        // Rounding Wind
        let z = weatherData.wind.speed
        let roundedz = (z*100).rounded()/100
        
        print (rounded)
        
        let roundedInt = Int(rounded)
        if roundedInt > 30 {
            self.tempState.text = "It's hot outside today!"
        } else if roundedInt > 20 {
            self.tempState.text = "Pretty warm, time for a swim?"
        } else if roundedInt > 10 {
            self.tempState.text = "Getting colder eh?"
        }
        
        // Setting text
        self.cityLabel.text = weatherData.name
        self.temperature.text = String(format: "%.2f",  rounded)
        self.weatherIcon.load(url: iconUrl!)
        self.wind.text = String(format: "%.2f", roundedz)
        self.weatherStatus.text = weatherData.weather[0].description
        self.realFeel.text = String(format: "%.2f", weatherData.main.feels_like)
        
        
    }
    
    // Does nothing???
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.searchTextField.text ?? "Error"

        fetchWeatherData(cityName: searchText, completionHandler: changeWeather)
    }
    
    // Tool for getting cities
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }

    // Get cities
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCities().count
    }
    
    // Populate tableView with Text
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let cities = getCities()
        cell.textLabel!.text = cities[indexPath.row]
        print("cell")
        
        return cell
    }
    
    // Change weather onClick
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let rowCity = cell?.textLabel?.text
        
        print("Clicked a row")
        
        fetchWeatherData(cityName: rowCity!, completionHandler: changeWeather)
    }
}

// Code snippet from: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
