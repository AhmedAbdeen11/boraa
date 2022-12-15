import UIKit
import Foundation

class Global {
    
    static let sharedInstance = Global()
    
    var baseUrl = "http://172.20.10.12:8000/api/v1/"
    var token: String = ""
    var tokenType: String = ""
    var user: User?
    
}
