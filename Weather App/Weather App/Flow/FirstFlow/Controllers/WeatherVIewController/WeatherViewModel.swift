import Foundation
import UIKit
import CoreLocation

struct City1: Codable {
    var name: String?
    let latitude, longitude: Double
}

struct ResultOfRequest: Codable {
    var results: [City1]?
}

struct Weather: Codable {
    let latitude, longitude: Double
    let hourly: Hourly
}

struct Hourly: Codable {
    let temperature2M: [Double]
    let windSpeed10M: [Double]
    let relativeHumidity2M: [Double]
    let time: [String]
    
    enum CodingKeys: String, CodingKey {
        case temperature2M = "temperature_2m"
        case windSpeed10M = "windspeed_10m"
        case relativeHumidity2M = "relativehumidity_2m"
        case time
    }
}

class WeatherViewModel: NSObject {
    var selectedCity: String = ""
    var latitude, longitude: Double?
    var locationManager = CLLocationManager()
    var showErrorAlert: ((String) -> Void)?
    var openNextScreen: ((City1) -> Void)?
    var cityName: ((String) -> Void)?
    var weather: ((Weather) -> Void)?
    
    func loadUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = 5.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func loadCityData() {
        let urlString: String = "https://geocoding-api.open-meteo.com/v1/search?name=\(selectedCity)&count=1"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { request, data, error in
                if let data = data {
                    if let result: ResultOfRequest = try? JSONDecoder().decode(ResultOfRequest.self, from: data) {
                        
                        if (result.results == nil) {
                            let alertError = UIAlertController(title: "Error", message: "Failed to load the city you selected.", preferredStyle: .alert)
                            alertError.addAction(UIAlertAction(title: "OK", style: .default))
                            self.showErrorAlert?("Error")
                        } else {
                            self.cityName?(result.results?.first?.name ?? "")
                            self.latitude = result.results?.first!.latitude
                            self.longitude = result.results?.first!.longitude
                            self.loadData()
                        }
                        
                        if let error = error {
                            let alertError = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            self.showErrorAlert?("Error")
                        }
                    }
                }
                
            }
            
        }
    }
    
    func loadData() {
        let urlString: String = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude ?? 0)&longitude=\(longitude ?? 0)&hourly=temperature_2m,relativehumidity_2m,windspeed_10m"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { request, data, error in
                if let data = data {
                    if let results: Weather = try? JSONDecoder().decode(Weather.self, from: data) {
                        self.weather?(results)
                    }
                }
                
                if let error = error {
                    let alertError = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    self.showErrorAlert?("Error")
                }
            }
        }
    }
    
}

extension WeatherViewModel: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            loadData()
        }
    }
}
