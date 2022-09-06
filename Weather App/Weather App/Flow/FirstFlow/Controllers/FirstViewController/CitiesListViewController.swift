import Foundation
import UIKit
import RxSwift

class CitiesListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var addNewCityButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var disposedBag = DisposeBag()
    var citiesArray: [String] = []
    let viewModel = CityListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "NavigationTableViewCell", bundle: nil), forCellReuseIdentifier: "NavigationTableViewCell")
        
        viewModel.cityArray.bind(to: tableView.rx.items(cellIdentifier: "NavigationTableViewCell", cellType: NavigationTableViewCell.self)) { index, item, cell in
            cell.configure(city: item)
        }.disposed(by: disposedBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.loadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        let weatherVModel = WeatherViewModel()
        weatherVModel.selectedCity = self.viewModel.cityArray.value[indexPath.row].name
                
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let weatherVC: WeatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {
            
            weatherVC.weatherVModel = weatherVModel

            self.navigationController?.pushViewController(weatherVC, animated: true)
        }
    }

}

enum UserDefaultsKey: String {
    case kCities = "kCities"
}
