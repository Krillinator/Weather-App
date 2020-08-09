//
//  ApiRequest.swift
//  WeatherAppFinal
//
//  Created by Kristoffer on 2020-08-03.
//  Copyright © 2020 Kristoffer. All rights reserved.
//

import Foundation

// Get WeatherData
// @Escaping - otherwise DispatchQueue.main.async does not work
func fetchWeatherData(cityName: String, completionHandler: @escaping (WeatherData) -> Void) {
    
    // INIT
    let city = cityName
    let key = "&appid=d40841e134c2029771aa807e589057f9"
    let source = "https://api.openweathermap.org/data/2.5/weather?q="
    let temperatureUnit = "&units=metric"
    let sourceUrl = source + city + key + temperatureUnit
    
    // Convert text to URL
    let url = URL(string: sourceUrl)!
    let request = URLRequest(url: url)
    
    let task = URLSession.shared.dataTask(with: request) {
        (data : Data?, response : URLResponse?, error : Error?) in
    
        if let unwrappedData = data {
            let decoder = JSONDecoder()
            do {
                let weatherData: WeatherData = try decoder.decode(WeatherData.self, from: unwrappedData)
                print("Decoding..")
                
                // Returning my weatherdata
                DispatchQueue.main.async {
                    completionHandler(weatherData)
                }
            } catch {
                print("Error parsing json: \(error)")
                print(sourceUrl)
            }
        } else {
            print("No data")
        }
    }
        task.resume()
}
