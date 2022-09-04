import Foundation
import Alamofire
import RxSwift
import RealmSwift

class CityService {
    
    var realm = try! Realm()
    
    init() {}
    
    func saveCity(city: City) {
        try! realm.write({
            self.realm.add(city)
        })
    }
    
    func getSavedCities() -> Results<City> {
        realm.objects(City.self)
    }
    
    func loadCityReactSingle(name: String ) -> Single<[City]>  {
        
        let urlSingle = Single<[City]>.create { single in
            
            let parameters: [String: String] = [
                "name": name,
            ]
            
            let request = AF.request("https://geocoding-api.open-meteo.com/v1/search?name=text", method: .get, parameters: parameters)
            request.responseData { responce in
                
                if let data = responce.data {
                    if let result = try? JSONDecoder().decode(CityResult.self, from: data) {
                        single(.success(result.results))
                    }
                }
                if let error = responce.error {
                    single(.failure(error))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
        return urlSingle
    }
    
}
