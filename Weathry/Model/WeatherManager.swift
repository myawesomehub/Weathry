//
//  WeatherManager.swift
//  Weathry
//
//  Created by mohammad mugish on 26/10/20.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager , weather : WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6fcda4db7aabf9cf2c61c59f04882b22&units=metric"
    
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with : urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees , longitude : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            task.resume()
        }
    }
    
    func handle(data : Data? , response : URLResponse? , error : Error?){
        if error != nil{
            delegate?.didFailWithError(error: error!)
            return
        }
        
        if let safeData = data {
            if let weather = parseJSON(safeData){
                delegate?.didUpdateWeather(self , weather : weather)
            }
        }
        
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            print(weather.conditionName)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
