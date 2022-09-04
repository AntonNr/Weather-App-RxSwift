import Foundation
import UIKit

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var weather: Weather?
    var weatherVModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if weatherVModel.selectedCity == "My Location"{
            locationLabel.text = "My Location"
            weatherVModel.loadUserLocation()
            weatherVModel.weather = { results in
                self.weather = results
                self.tableView.reloadData()
            }
            weatherVModel.showErrorAlert = { text in
                let alert = UIAlertController(title: text, message: "Failed to load the city you selected.", preferredStyle: .alert)
                self.present(alert, animated: true)
            }
        } else {
            weatherVModel.loadCityData()
            weatherVModel.cityName = { text in
                self.locationLabel.text = text
            }
            weatherVModel.weather = { results in
                self.weather = results
                self.tableView.reloadData()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.hourly.time.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell {
            
            let currentTime =  weather?.hourly.time[indexPath.row]
            let currentTemperature = weather?.hourly.temperature2M[indexPath.row]
            let currentWindSpeed = weather?.hourly.windSpeed10M[indexPath.row]
            let currentHumidity = weather?.hourly.relativeHumidity2M[indexPath.row]
            
            cell.timeLabel.text = "\(currentTime!)"
            cell.temperatureLabel.text = "\(currentTemperature!)°"
            cell.windSpeedLabel.text = "\(currentWindSpeed!)km/h"
            cell.humidityLabel.text = "\(currentHumidity!)%"
                    
            return cell
        }
        return UITableViewCell()
    }
    
}
