import Foundation
import RealmSwift

struct CityResult: Codable {
    var results: [City] = []
}

class City: Object, Codable {

   @Persisted var id: Int = 0
   @Persisted var name: String = ""
   @Persisted var country: String? = ""
   @Persisted var latitude: Double = 0.0
   @Persisted var longitude: Double = 0.0
}
