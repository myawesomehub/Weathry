//
//  ViewController.swift
//  Weathry
//
//  Created by mohd yasir on 25/10/20.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextFeild: UITextField!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchTextFeild.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func currentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
}




extension WeatherViewController : UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextFeild.endEditing(true)
        print(searchTextFeild.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextFeild.endEditing(true)
        print(searchTextFeild.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            searchTextFeild.placeholder = "Enter City Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextFeild.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextFeild.text = ""
    }
    
}

extension WeatherViewController : WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager : WeatherManager , weather : WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension WeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude : lat , longitude : lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
