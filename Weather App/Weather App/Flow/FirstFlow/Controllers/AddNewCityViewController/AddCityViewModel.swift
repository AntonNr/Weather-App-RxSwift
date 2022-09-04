import Foundation
import RxSwift
import RxRelay


class AddNewCityViewModel {
    
    let cityService = CityService()

    let cityArray = BehaviorRelay<[City]>(value: [])
    
    func loadData(searchText: String) {
        cityService.loadCityReactSingle(name: searchText).subscribe { [weak self] items in
            print(items)
            self?.cityArray.accept(items)
        } onFailure: { error in
            print(error)
        } onDisposed: {
            print("onDisposed")
        }
    }
    
    func saveCity(index: Int) {
        let city = cityArray.value[index]
        cityService.saveCity(city: city)
        print(city)
    }
    
}
