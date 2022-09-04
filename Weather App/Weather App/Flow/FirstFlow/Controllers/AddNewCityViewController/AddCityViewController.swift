import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

class AddNewCityViewController: UIViewController {
    
    let viewModel = AddNewCityViewModel()
    open var disposeBag = DisposeBag()
    
    @IBOutlet var rootVeiw: AddNewCityView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchCityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "NavigationTableViewCell", bundle: nil), forCellReuseIdentifier: "NavigationTableViewCell")
        
        searchCityTextField.rx.text.subscribe(onNext: { [weak self] text in
            self?.viewModel.loadData(searchText: text ?? "")
        }).disposed(by: disposeBag)
            
        viewModel.cityArray.bind(to: tableView.rx.items(cellIdentifier: "NavigationTableViewCell", cellType: NavigationTableViewCell.self)) { index, item, cell in
            cell.configure(city: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.viewModel.saveCity(index: indexPath.row)
            self?.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}


