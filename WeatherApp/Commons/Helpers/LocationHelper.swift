//
//  LocationHelper.swift
//  WeatherApp
//
//  Created by mohammad suhail on 6/6/22.
//

import Foundation
import MapKit

class LocationHelper {
    
    static func findCountry(withName name: String, mapView: MKMapView, completion: @escaping ((MKCoordinateRegion?) -> ())){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                completion(nil)
                return
            }
            if let latitude = response.mapItems.first?.placemark.coordinate.latitude,
               let longitude = response.mapItems.first?.placemark.coordinate.longitude {
                completion(self.getNewRegion(latitude: latitude, longitude: longitude))
            }
        }
    }
    
    static func getNewRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees, regionRadius: CLLocationDistance = 200000) -> MKCoordinateRegion {
        let newCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return MKCoordinateRegion(center: newCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    }
    
    static func getTappedLocation(mapView: MKMapView, gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D {
        let touchPoint = gestureRecognizer.location(in: mapView)
        return mapView.convert(touchPoint, toCoordinateFrom: mapView)
    }
    
    static func destinationBy(coordinates: CLLocationCoordinate2D, distance: CLLocationDistance = 200000, direction: LocationDirection) -> CLLocation {
        let earthRadius = 6372.7976
        let angularDistance = (distance / 1000) / earthRadius
        let originLatRad = coordinates.latitude * (Double.pi / 180)
        let originLngRad = coordinates.longitude * (Double.pi / 180)
        let directionRad = direction.rawValue * (Double.pi / 180)
        
        let destinationLatRad = asin(
            sin(originLatRad) * cos(angularDistance) +
            cos(originLatRad) * sin(angularDistance) *
            cos(directionRad))
        
        let destinationLngRad = originLngRad + atan2(
            sin(directionRad) * sin(angularDistance) * cos(originLatRad),
            cos(angularDistance) - sin(originLatRad) * sin(destinationLatRad))
        
        let destinationLat: CLLocationDegrees = destinationLatRad * (180 / Double.pi)
        let destinationLng: CLLocationDegrees = destinationLngRad * (180 / Double.pi)
        
        return CLLocation(latitude: destinationLat, longitude: destinationLng)
    }
    
    static func makeAnnotation(withTitle title: String, coordinates: CLLocationCoordinate2D) -> MKPointAnnotation{
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = coordinates
        return annotation
    }
    
}
