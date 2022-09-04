import Foundation
import RxSwift
import RxRelay

class CityListViewModel {
    
    let cityService = CityService()
    
    let cityArray = BehaviorRelay<[City]>(value: [])
    
    func loadData() {
        var cities: [City] = []
        
        let savedData = cityService.getSavedCities()
        
        savedData.forEach { city in
            cities.append(city)
        }
        cityArray.accept(cities)
    }
}
