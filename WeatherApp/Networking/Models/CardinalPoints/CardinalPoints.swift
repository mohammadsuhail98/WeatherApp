//
//  CardinalPoints.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation
import MapKit

struct CardinalPoints {
    
    private var originalLocation: CLLocationCoordinate2D?

    var north: CLLocationCoordinate2D {
        get {
            return LocationHelper.destinationBy(coordinates: getOriginalLocation(), direction: .north).coordinate
        }
    }
    var south: CLLocationCoordinate2D {
        get {
            return LocationHelper.destinationBy(coordinates: getOriginalLocation(), direction: .south).coordinate
        }
    }
    var east: CLLocationCoordinate2D {
        get {
            return LocationHelper.destinationBy(coordinates: getOriginalLocation(), direction: .east).coordinate
        }
    }
    var west: CLLocationCoordinate2D {
        get {
            return LocationHelper.destinationBy(coordinates: getOriginalLocation(), direction: .west).coordinate
        }
    }
        
    init(originalLocation: CLLocationCoordinate2D? = nil){
        self.originalLocation = originalLocation
    }
    
    private func getOriginalLocation() -> CLLocationCoordinate2D {
        guard let originalLocation = originalLocation else {
            return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
        return originalLocation
    }
    
}
