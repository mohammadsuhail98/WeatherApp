//
//  Weather.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    var lat, lon: Double?
    var current: CurrentWeather?
    var hourly: [CurrentWeather]?

    var lastHourRain: Double? {
        if hourly != nil && !(hourly?.isEmpty ?? true) {
            if let rain = hourly?.first?.rain {
                return rain.the1H
            }
            return nil
        }
        return nil
    }
    
    var cardinalPoint: LocationDirection? = nil

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case current, hourly
    }
}
