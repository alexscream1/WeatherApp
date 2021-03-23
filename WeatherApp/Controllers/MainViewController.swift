//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alexey Onoprienko on 17.03.2021.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    var networkWeatherManager = NetworkWeatherManager()
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // Create Location Manager, lazy var in case user not allowed to use current location
    lazy var locationManager : CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterface(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            // Requests the one-time delivery of the user’s current location
            locationManager.requestLocation()
        }
    }

    
    @IBAction func searchButton(_ sender: UIButton) {
        searchAlertController(title: "Enter city name", message: nil, preferredStyle: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCityWeather(requestType: .city(city: city))
        }
    }
    
    func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.tempString
            self.feelsLikeTemperatureLabel.text = "\(weather.feelsLikeTempString) °C"
            self.weatherImageView.image = UIImage(systemName: weather.weatherImage)
        }
    }
    
}


extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        self.networkWeatherManager.fetchCityWeather(requestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
