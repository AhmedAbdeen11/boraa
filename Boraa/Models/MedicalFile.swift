import Foundation
import ObjectMapper

struct MedicalFile : Mappable {
    
    var id : Int?
    var type : Int?
    var userId : Int?
    var image : String?

    init?() {

    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        type <- map["type"]
        userId <- map["user_id"]
        image <- map["image"]
        
    }

}
