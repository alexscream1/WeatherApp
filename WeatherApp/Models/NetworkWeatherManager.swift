//
//  NetworkWeatherManager.swift
//  WeatherApp
//
//  Created by Alexey Onoprienko on 17.03.2021.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    enum RequestType {
        case city(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    func fetchCityWeather(requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .city(city: let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(latitude: let latitude, longitude: let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        
        fetchCityWithURL(withURL: urlString)
    }
    
    
    fileprivate func fetchCityWithURL(withURL url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch weather:", error)
                return
            }
            
            if let data = data {
                guard let currentWeather = self.parseJSON(forData: data) else { return }
                self.onCompletion?(currentWeather)
                
            }
        }
        dataTask.resume()
    }
    
    fileprivate func parseJSON(forData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        
        do {
             let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            
            return currentWeather
            
        } catch let error {
            print("Failed to parseJSON", error)
        }
        return nil
    }
}
