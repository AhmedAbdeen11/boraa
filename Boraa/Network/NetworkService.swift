import Foundation
import Moya

public enum NetworkService {
    
    // MARK: - User
    
    case register(params: [String: Any])
    
    case login(params: [String: Any])
    
    case myData(params: [String: Any])
    
    case getUserById(params: [String: Any])
    
    case logout
    
    case getClinics
    
    case getAvailableTimes(params: [String: Any])
    
    case book(params: [String: Any])
    
    case bookAtWaitingList(params: [String: Any])
    
    case getMyBooks
    
    case getMyUpcomingBooks
    
    case cancelBook(params: [String: Any])
    
    case rescheduleBook(params: [String: Any])
    
    case confirmBook(params: [String: Any])
    
    case getMedicalFiles(params: [String: Any])
    
}

extension NetworkService: TargetType {
    
    public var baseURL: URL { return URL(string: Global.sharedInstance.baseUrl)! }
    
    public var headers: [String: String]? {
        switch self {
            
        case .login, .register:
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
            
        default: return [
                "Authorization": "Bearer \(Global.sharedInstance.token)",
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
            ]
            
    }

    }
    
    public var path: String {
        switch self {
        
            // MARK: - User
        
            case .register:
                return "register"
            
            case .login:
                return "login"
             
            case .myData:
                return "me"
            
            case .getUserById:
                return "user"
            
            case .logout:
                return "logout"
            
            case .getClinics:
                return "clinic"
            
            case .getAvailableTimes:
                return "clinic/available-times"
            
            case .book:
                return "book"
            
            case .bookAtWaitingList:
                return "waiting"
            
            case .getMyBooks:
                return "my-books"
            
            case .getMyUpcomingBooks:
                return "my-upcoming-books"
            
            case .cancelBook:
                return "cancel-book"
            
            case .rescheduleBook:
                return "reschedule-book"
            
            case .confirmBook:
                return "confirm-book"
            
            case .getMedicalFiles:
                return "my-medical-files"

        }
    }
    
    public var method: Moya.Method {
        switch self {
        
        case .register, .login, .myData, .getUserById, .getAvailableTimes, .book, .bookAtWaitingList, .cancelBook, .rescheduleBook, .confirmBook, .getMedicalFiles:
                return .post
                
            default:
                return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {

        switch self {
        
        
        
        // MARK: - Form + one image
        
      
        // MARK: - Form
            
        case let .login(params: params),
             let .register(params: params),
             let .myData(params: params),
             let .getUserById(params: params),
             let .getAvailableTimes(params: params),
             let .book(params: params),
             let .bookAtWaitingList(params: params),
             let .cancelBook(params: params),
             let .rescheduleBook(params: params),
             let .confirmBook(params: params),
             let .getMedicalFiles(params: params):
             return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        // MARK: - Form + list of images
        
        default :
            return .requestPlain
            
        }
    }
}
