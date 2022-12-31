import Foundation
import ObjectMapper

struct User : Mappable {
    
    var id : Int?
    var name : String?
    var medicalNumber : String?
    var phoneNumber : String?
    var timeZone : String?
    var language : String?
    var loginType: String! = "email"
    var hospitalId : Int?
    var hospital : Hospital?

    init?() {

    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        medicalNumber <- map["medical_number"]
        phoneNumber <- map["phone_number"]
        timeZone <- map["time_zone"]
        language <- map["language"]
        loginType <- map["login_type"]
        hospitalId <- map["hospital_id"]
        hospital <- map["hospital"]
        
    }

}
