//
//  ViewController.swift
//  WeatherApp
//
//  Created by Валентина Калайда on 25.02.2020.
//  Copyright © 2020 Валентина Калайда. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        getCurrentWeatherData()
    }
    
    func toggleActivityIndicator(on: Bool) {
        
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    lazy var weatherManager = APIWeatherManager(apiKey: "8f247ceefd09e1895b68b5e3d3cfa8ba")
    let coordinates = Coordinates(latitude: 50.453743, longitude: 30.525322)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        getCurrentWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        
        print("My location latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
    }
    
    func getCurrentWeatherData() {
        
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            self.toggleActivityIndicator(on: false)
                   switch result {
                       case .Success(let currentWeather):
                           self.updateUIWith(currentWeather: currentWeather)
                   case .Failure(let error as NSError):
                       
                       let alertController = UIAlertController(title: "Unable to get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                       alertController.addAction(okAction)
                       
                       self.present(alertController, animated: true, completion: nil)
                   default: break
                   }
               }
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.appearentTemperatureLabel.text = currentWeather.appearentTemperatureString
        self.humidityLabel.text = currentWeather.humidityString
    }
}

