//
//  Weather.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let hourly: [CurrentWeather]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly
    }
}
