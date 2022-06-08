//
//  Data+Extension.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation


extension Data {
    var toJSON: AnyObject?{
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    static func decode<T : Decodable>(json: Any?, type: T.Type, errorAttributes: [String] = [], errorMessage: String? = nil) -> (T?, NSError?) {
        guard let json = json, !(json is NSNull) else {return (nil, NSError(domain: "", code: 400, userInfo: nil))}
        
        do {
            for e in errorAttributes{
                if let message = (json as AnyObject)[e] as? String{
                    return (nil, NSError(domain: "", code: 400, userInfo: ["message" : message]))
                }
            }
            
            if let jsonData = Data.jsonToData(json: json as AnyObject){
                let response = try JSONDecoder().decode(type, from: jsonData)
                return (response, nil)
            }else{
                return (nil, NSError(domain: "", code: 400, userInfo: ["message" : errorMessage ?? ""]))
            }
        } catch let e{
            return (nil, e as NSError)
        }
    }
    
}

private extension Data {
    static func jsonToData(json: AnyObject?) -> Data?{
        guard let json = json, !(json is NSNull) else {return nil}
        
        if !JSONSerialization.isValidJSONObject(json) {
            return nil
        }
        
        do {
            return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
