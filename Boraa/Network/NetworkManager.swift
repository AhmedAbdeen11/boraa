//
//  NetworkAdapter.swift
//  Kelkou TV
//
//  Created by Mac on 8/1/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import RxSwift
import Moya

class NetworkManager: NSObject {
        
    let provider = MoyaProvider<NetworkService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    // MARK: - User
    
    func login(params: [String: Any]) -> Single<Any> {
        return provider.rx
            .request(.login(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
    }
    
    func getCurrentUser(params: [String: Any]) -> Single<String> {
        return provider.rx
            .request(.myData(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapString()
    }
    
    func register(params: [String: Any]) -> Single<Any> {
        return provider.rx
            .request(.register(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
    }

    func getUserById(params: [String: Any]) -> Single<String> {
        return provider.rx
            .request(.getUserById(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapString()
    }
    
    func logout() -> Completable
    {
        return provider.rx
            .request(.logout)
            .filterSuccessfulStatusAndRedirectCodes()
            .asObservable()
            .ignoreElements()
    }
  
    func getClinics() -> Single<String> {
        return provider.rx
            .request(.getClinics)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapString()
    }
    
    func getAvailableTimes(params: [String: Any]) -> Single<Any> {
        return provider.rx
            .request(.getAvailableTimes(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
    }
    
    func book(params: [String: Any]) -> Completable {
        return provider.rx
            .request(.book(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .asObservable()
            .ignoreElements()
    }
    
    func myBooks() -> Single<String> {
        return provider.rx
            .request(.getMyBooks)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapString()
    }
    
    func myUpcomingBooks() -> Single<String> {
        return provider.rx
            .request(.getMyUpcomingBooks)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapString()
    }
    
    func cancelBook(params: [String: Any]) -> Completable {
        return provider.rx
            .request(.cancelBook(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .asObservable()
            .ignoreElements()
    }
    
    func rescheduleBook(params: [String: Any]) -> Completable {
        return provider.rx
            .request(.rescheduleBook(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .asObservable()
            .ignoreElements()
    }
    
    func confirmBook(params: [String: Any]) -> Completable {
        return provider.rx
            .request(.confirmBook(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .asObservable()
            .ignoreElements()
    }
    
    func getMedicalFiles(params: [String: Any]) -> Single<String> {
        return provider.rx
            .request(.getMedicalFiles(params: params))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapString()
    }
    
    
}
