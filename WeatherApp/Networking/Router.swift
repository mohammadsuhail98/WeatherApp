//
//  Router.swift
//  WeatherApp
//
//  Created by mohammad suhail on 6/6/22.
//

import Foundation
import Alamofire

enum Router {
    case fetchWeatherData(lat: String, lon: String, exclude: String, appId: String)
}

extension Router {
    
    var scheme: String {
        switch self {
        case  .fetchWeatherData:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case  .fetchWeatherData:
            return "api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case  .fetchWeatherData:
            return "/data/2.5/onecall"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchWeatherData(let lat, let lon, let exclude, let appId):
            return [URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "lon", value: lon),
                    URLQueryItem(name: "exclude", value: exclude),
                    URLQueryItem(name: "appid", value: appId)]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchWeatherData:
            return .get
        }
    }
    
}
