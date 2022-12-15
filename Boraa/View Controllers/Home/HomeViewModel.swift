import Foundation

import RxSwift
import Moya
import SwiftyJSON

class HomeViewModel {
    
    let provider = NetworkManager()
 
    func getCurrentUser(params: [String: Any]) -> Single<User> {
        
        return .create (subscribe: { observer in
            
          self.provider.getCurrentUser(params: params)
                .subscribe(onSuccess: { serverResponse in
                  
                    let serverModel = BaseResponseObject<User>(JSONString: serverResponse)
                    
                    observer(.success((serverModel?.data)!))
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
 
    func myUpcomingBooks() -> Single<[Book]> {
        
        return .create (subscribe: { observer in
            
          self.provider.myUpcomingBooks()
                .subscribe(onSuccess: { serverResponse in
                  
                    let serverModel = BaseResponseArray<Book>(JSONString: serverResponse)
                    
                    observer(.success((serverModel?.data)!))
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
    
    func confirmBook(params: [String: Any]) -> Completable {
        
        return .create (subscribe: { observer in
            
          self.provider.confirmBook (params: params)
                .subscribe(onCompleted: {
                  
                    observer(.completed)
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
    
}

