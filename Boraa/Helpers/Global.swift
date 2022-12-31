import UIKit
import Foundation

class Global {
    
    static let sharedInstance = Global()
    
    var baseUrl = "https://boraa.solidbundle.com/api/v1/"
    var token: String = ""
    var tokenType: String = ""
    var user: User?
    
}
