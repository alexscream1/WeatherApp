//
//  SearchAlertExtension.swift
//  WeatherApp
//
//  Created by Alexey Onoprienko on 17.03.2021.
//

import UIKit

extension MainViewController {
    
    // Create alert controller for searching city current weather
    func searchAlertController(title: String?, message: String?, preferredStyle: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        // Add random placeholder for text field
        alertController.addTextField { (textfield) in
            let cities = ["New York", "Kyiv", "Cape Town", "London", "Dubai", "Hong Kong"]
            textfield.placeholder = cities.randomElement()
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { (action) in
            // Check if text field isn't empty
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                // Delete spacing between two-words cities
                let city = cityName.split(separator: " ").joined(separator: "%20")
                // Saved city name for transfer data with escaping closure
                completionHandler(city)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
