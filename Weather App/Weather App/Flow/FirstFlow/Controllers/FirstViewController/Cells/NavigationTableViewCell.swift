import Foundation
import UIKit

class NavigationTableViewCell: UITableViewCell {
    
    @IBOutlet var cityNameLabel: UILabel!
    
    func configure(city: City) {
        cityNameLabel.text = city.name
    }
}
