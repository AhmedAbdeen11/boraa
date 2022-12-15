import Foundation

import RxSwift
import Moya
import SwiftyJSON

class SelectClinicViewModel {
    
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
    
}

