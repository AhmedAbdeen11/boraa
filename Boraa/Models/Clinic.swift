import Foundation
import ObjectMapper

struct Clinic : Mappable {
    
    var id : Int?
    var name : String?

    init?() {

    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        
    }

}
