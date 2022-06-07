//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherAPIManager: APIClient {
    
    class func getWeather(route: Router, _ successBlock: ((Weather?) -> ())? = nil, errorBlock: ((NSError) -> ())? = nil){
        
        createRequest(withRoute: route, successBlock: { (json) in
            
            let response = Data.decode(json: json, type: Weather.self)
            if let error = response.1 {
                errorBlock?(error)
                return
            }
            successBlock?(response.0)
            
        }){ (error) in
            errorBlock?(error)
        }
    }
    
}
