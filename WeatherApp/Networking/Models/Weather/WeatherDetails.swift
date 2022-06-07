//
//  WeatherDetails.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation

// MARK: - WeatherDetails
struct WeatherDetails: Codable {
    let id: Int
    let main: Main
    let weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}
