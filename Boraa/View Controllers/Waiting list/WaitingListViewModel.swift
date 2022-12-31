import Foundation

import RxSwift
import Moya
import SwiftyJSON

class WaitingListViewModel {
    
    let provider = NetworkManager()
    
    func getClincs() -> Single<[Clinic]> {
        
        return .create (subscribe: { observer in
            
          self.provider.getClinics()
                .subscribe(onSuccess: { serverResponse in
                  
                    let serverModel = BaseResponseArray<Clinic>(JSONString: serverResponse)
                    
                    observer(.success((serverModel?.data)!))
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
    
    func getAvailableTimes(params: [String: Any]) -> Single<[String]> {
        
        return .create (subscribe: { observer in
            
          self.provider.getAvailableTimes(params: params)
                .subscribe(onSuccess: { serverResponse in
                  
                    do {
                        let json = JSON(serverResponse)
                        
                        let times =  json["data"].arrayValue.map {$0.stringValue}

                        observer(.success((times)))
                        
                    }
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
    
    func bookAtWaitingList(params: [String: Any]) -> Completable {
        
        return .create (subscribe: { observer in
            
          self.provider.bookAtWaitingList(params: params)
                .subscribe(onCompleted: {
                  
                    observer(.completed)
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
    
}

