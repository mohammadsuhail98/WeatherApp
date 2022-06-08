//
//  ViewController.swift
//  WeatherApp
//
//  Created by mohammad suhail on 4/6/22.
//

import UIKit
import MapKit
import CoreLocation

class HomeController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    fileprivate var viewModel: HomeViewModel?
    fileprivate var cardinalPoints = CardinalPoints()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        setupUI()
    }
    
    func setupUI(){
        setupSearchBar()
        setupLocationManager()
        setupMapView()
    }
    
    func setupMapView(){
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        addOnUserTapAction(mapView: mapView, target: self, action: #selector(addAnnotation))
    }
    
    func setupSearchBar(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
        searchBar.placeholder = "Type a City/Zip Code"
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.searchBarStyle = .minimal
        searchBar.setTextColor(color: .gray)
        searchBar.setSearchImageColor(color: .lightGray)
        searchBar.setTextFieldClearButtonColor(color: .gray)
        searchBar.setSearchPlaceholderFont(font: UIFont(name: "Saira-Regular", size: 15)!)
    }
    
    func setNewRegion(withName name: String){
        LocationHelper.findCountry(withName: name, mapView: self.mapView) { [weak self] region in
            guard let self = self else { return }
            if let region = region {
                self.mapView.setRegion(region, animated: true)
            } else {
                self.presentAlert(title: "Sorry!", messsage: "We could not find the city/zip code you entered")
            }
        }
    }
    
    @objc func addAnnotation(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == .began {
            let originalLocation = LocationHelper.getTappedLocation(mapView: mapView, gestureRecognizer: gestureRecognizer)
            let annotation = LocationHelper.makeAnnotation(withTitle: "You created this annotation!", coordinates: originalLocation)
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)
            
            cardinalPoints = CardinalPoints(originalLocation: originalLocation)
            viewModel?.locations.removeAll()
            viewModel?.locationCount = 0
            fetchWeatherData(withLocation: originalLocation)
            
            fetchWeatherData(withLocation: cardinalPoints.north, point: .north)
            fetchWeatherData(withLocation: cardinalPoints.south, point: .south)
            fetchWeatherData(withLocation: cardinalPoints.east, point: .east)
            fetchWeatherData(withLocation: cardinalPoints.west, point: .west)
        }
    }
    
    func fetchWeatherData(withLocation location: CLLocationCoordinate2D, point: LocationDirection? = nil){
        viewModel?.location = location
        viewModel?.exclude = "daily,minutely,alerts"
        viewModel?.fetchData(cardinalPoint: point)
    }
    
    func addOnUserTapAction(mapView: MKMapView, target: AnyObject, action: Selector, tapDuration: Double = 1) {
        let longPressRecognizer = UILongPressGestureRecognizer(target: target, action: action)
        longPressRecognizer.minimumPressDuration = tapDuration
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    func setupLocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }

}

extension HomeController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        closeKeyboard()
        setNewRegion(withName: searchBar.text ?? "")
    }
    
}

extension HomeController: HomeViewModelDelegate {
    
    func dataFetched(weather: [Weather]) {
        let highestTemp = weather.filter({ $0.current?.highestTemp ?? false}).first ?? Weather()
        let highestHum = weather.filter({ $0.current?.highestHumidity ?? false}).first ?? Weather()
        let highestWindSpeen = weather.filter({ $0.current?.highestWindSpeed ?? false}).first ?? Weather()
        let highestRainRate = weather.filter({ $0.current?.highestRainRate ?? false}).first ?? Weather()

        print("\(highestTemp.cardinalPoint?.title ?? "The Original Location") has the highest temperature: \(highestTemp.current?.tempC ?? 0)")
        print("\(highestHum.cardinalPoint?.title ?? "The Original Location") has the highest humidity: \(highestHum.current?.humidity ?? 0)")
        print("\(highestWindSpeen.cardinalPoint?.title ?? "The Original Location") has the highest wind Speed: \(highestWindSpeen.current?.windSpeed ?? 0)")
        if let rain = highestRainRate.lastHourRain {
            print("\(highestRainRate.cardinalPoint?.title ?? "The Original Location") has the highest rain amount: \(rain)")
        } else {
            print("It has not been rainig in any of the locations")
        }
    }
    
    func errorOccured(error: Error) {
        self.presentAlert(title: "Sorry!", messsage: error.localizedDescription)
    }
    
}
