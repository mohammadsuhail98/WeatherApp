//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    var dt: Int?
    var temp: Double?
    var humidity: Int?
    var windSpeed: Double?
    var rain: Rain?
    
    var tempC: Double? {
        if let temp = temp {
            return Double(String(format: "%.1f", (temp) - 273.15))
        } else {
            return nil
        }
    }
    var rainAmount: Double? {
        return rain?.the1H
    }
    
    var highestTemp: Bool? = false
    var highestHumidity: Bool? = false
    var highestWindSpeed: Bool? = false
    var highestRainRate: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case dt, temp
        case humidity
        case windSpeed = "wind_speed"
        case rain
    }
}
