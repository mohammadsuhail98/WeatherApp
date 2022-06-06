//
//  NetworkCalls.swift
//  WeatherApp
//
//  Created by mohammad suhail on 6/6/22.
//

import Foundation
import Alamofire

class NetworkCall {
    
    static func requestData(router: Router, completion: @escaping (Bool) -> ()) {
        
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.queryItems
        guard let url = components.url else { return }
        print(url)
        print("\n---------------- API: START ----------------")
        print("API: URL - \(url.absoluteURL)")
        print("API: METHOD - \(router.method)")
        if let parameters = router.queryItems {
            print("API: BODY - \(parameters)")
        }
        print("---------------- API: END----------------\n")
        
        if !Connectivity.isConnectedToInternet {
            // add completion
            return
        }
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120

        manager.request(url, method: router.method).validate().responseData { (response) in
            if response.result.isSuccess {
                if response.response?.statusCode ?? 0 == 200 {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("Error \(String(describing: response.result.error)) while fetching all Info for url : \(url)")
                completion(false)
            }
        }
    }
    
}

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager(host: "https://google.com")!.isReachable
    }
}
