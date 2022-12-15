import Foundation
import ObjectMapper

struct Book : Mappable {
    
    var id : Int?
    var date : String?
    var time : String?
    var isConfirmed : Bool?
    var day: String?
    var dateFormatted : String?
    var clinic : Clinic?

    init?() {

    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        date <- map["date"]
        time <- map["time"]
        isConfirmed <- map["is_confirmed"]
        day <- map["day"]
        dateFormatted <- map["date_formatted"]
        clinic <- map["clinic"]
        
    }

}
