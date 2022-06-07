//
//  NetworkCalls.swift
//  WeatherApp
//
//  Created by mohammad suhail on 6/6/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    
    static func createRequest(withRoute route: Router, successBlock: ((AnyObject) -> Void)? = nil, errorBlock: ((NSError) -> Void)? = nil){
        createRequest(router: route) { data in
            successBlock?(data)
        } errorBlock: { error in
            errorBlock?(error)
        }
    }
    
}

private extension APIClient {
    
    static func createRequest(router: Router, successBlock: ((AnyObject) -> Void)? = nil, errorBlock: ((NSError) -> Void)? = nil) {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.queryItems
        guard let url = components.url else { return }

        print("\n---------------- API: START ----------------")
        print("API: URL - \(url.absoluteURL)")
        print("API: METHOD - \(router.method)")
        if let parameters = router.queryItems {
            print("API: BODY - \(parameters)")
        }
        print("---------------- API: END----------------\n")
        
        if !Connectivity.isConnectedToInternet {
            errorBlock?(NSError(domain: "Could not connect to internet", code: 0))
            return
        }
        
        AF.request(url, method: router.method).validate().responseJSON { (response) in
            
            if response.response?.statusCode ?? 0 != 200 {
                if let err = JSON(response.data ?? Data()).dictionaryObject {
                    guard let errTitle = err["title"] as? String else {
                        if let err = response.error{
                            let e = err as NSError
                            let error = NSError(domain: e.domain, code: response.response?.statusCode ?? e.code, userInfo: e.userInfo)
                            errorBlock?(error)
                            return
                        }
                        return
                    }
                                
                    let e = NSError(domain: errTitle,
                                    code: response.response?.statusCode ?? 0,
                                    userInfo: [ "message" : NSLocalizedString("Bad Request", value: errTitle, comment: "") ]
                    )
                    errorBlock?(e)
                    return
                }
            }
            
            if let err = response.error{
                let e = err as NSError
                let error = NSError(domain: e.domain, code: response.response?.statusCode ?? e.code, userInfo: e.userInfo)
                errorBlock?(error)
                return
            }
            
            switch response.result {
            case .success(let data):
                successBlock?(data as AnyObject)
            case .failure(let error):
                errorBlock?(error as NSError)
            }

        }
    }
    
}

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager(host: "https://google.com")!.isReachable
    }
}
