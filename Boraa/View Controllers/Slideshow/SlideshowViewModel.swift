import Foundation

import RxSwift
import Moya
import SwiftyJSON

class SlideshowViewModel {
    
    let provider = NetworkManager()
  
    func getMedicalFiles(params: [String: Any]) -> Single<[MedicalFile]> {
        
        return .create (subscribe: { observer in
            
          self.provider.getMedicalFiles(params: params)
                .subscribe(onSuccess: { serverResponse in
                  
                    let serverModel = BaseResponseArray<MedicalFile>(JSONString: serverResponse)
                    
                    observer(.success((serverModel?.data)!))
                    
                }, onError: { error in
                    
                    observer(.error(error))
                    
                })
        })
        
    }
}

