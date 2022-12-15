import Foundation

import RxSwift
import Moya
import SwiftyJSON

class AppointmentsViewModel {
    
    let provider = NetworkManager()
    
    func myBooks() -> Single<[Book]> {
        
        return .create (subscribe: { observer in
            
          self.provider.myBooks()
                .subscribe(onSuccess: { serverResponse in
                  
                    let serverModel = BaseResponseArray<Book>(JSONString: serverResponse)
                    
                    observer(.success((serverModel?.data)!))
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
    
    func cancelBook(params: [String: Any]) -> Completable {
        
        return .create (subscribe: { observer in
            
          self.provider.cancelBook (params: params)
                .subscribe(onCompleted: {
                  
                    observer(.completed)
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
    
}

