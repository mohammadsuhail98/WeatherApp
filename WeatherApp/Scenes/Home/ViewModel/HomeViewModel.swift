//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by mohammad suhail on 7/6/22.
//

import Foundation
import CoreLocation

class HomeViewModel {
    fileprivate var delegate: HomeViewModelDelegate?
    
    var location: CLLocationCoordinate2D?
    var exclude: String?
    var locations = [Weather]()
    
    var locationCount: Int = 0 {
        didSet {
            if locationCount == 5 { self.processFinalWeatherData() }
        }
    }
    
    init(delegate: HomeViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func fetchData(cardinalPoint: LocationDirection? = nil){
        guard let location = location else {
            self.delegate?.errorOccured(error: NSError(domain: "Location could not be found", code: 0))
            return
        }
        WeatherAPIManager.getWeather(route: .fetchWeatherData(lat: location.latitude.toString, lon: location.longitude.toString, exclude: exclude ?? "", appId: Constants.appID)) { [weak self] weather in
            guard let self = self, let weather = weather else { return }
            
            var tempWeather = weather
            if let cardinalPoint = cardinalPoint { tempWeather.cardinalPoint = cardinalPoint }
            self.locations.append(tempWeather)
            self.locationCount += 1
            
        } errorBlock: { error in
            self.delegate?.errorOccured(error: error)
        }
    }
    
    func processFinalWeatherData(){

        var highestTempLocation = locations.sorted(by: { $0.current?.tempC ?? 0 > $1.current?.tempC ?? 0}).first ?? Weather()
        highestTempLocation.current?.highestTemp = true
        
        var highestHumLocation = locations.sorted(by: { $0.current?.humidity ?? 0 > $1.current?.humidity ?? 0}).first ?? Weather()
        highestHumLocation.current?.highestHumidity = true
        
        let locationsWithRain = locations.filter({ $0.lastHourRain != nil })
        var highestRainLocation = locationsWithRain.sorted(by: { $0.lastHourRain ?? 0 > $1.lastHourRain ?? 0}).first ?? Weather()
        highestRainLocation.current?.highestRainRate = true
        
        var highestWindSpeedLocation = locations.sorted(by: { $0.current?.windSpeed ?? 0 > $1.current?.windSpeed ?? 0}).first ?? Weather()
        highestWindSpeedLocation.current?.highestWindSpeed = true
        
        self.delegate?.dataFetched(weather: [highestTempLocation, highestHumLocation, highestWindSpeedLocation, highestRainLocation])
        
    }
    
}

protocol HomeViewModelDelegate {
    func dataFetched(weather: [Weather])
    func errorOccured(error: NSError)
}
