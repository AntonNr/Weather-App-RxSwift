import Foundation
import UIKit

class NavigationTableViewCell: UITableViewCell {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var countryNameLabel: UILabel!
    
    func configure(city: City) {
        cityNameLabel.text = city.name
        countryNameLabel.text = city.country
    }
}
