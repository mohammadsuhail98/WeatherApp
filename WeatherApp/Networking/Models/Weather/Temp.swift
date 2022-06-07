//
//  Temp\.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
