//
//  Rain.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation

// MARK: - Rain
struct Rain: Codable {
    var the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}
