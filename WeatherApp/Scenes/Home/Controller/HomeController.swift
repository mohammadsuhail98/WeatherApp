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
    
    var cardinalPoints = CardinalPoints()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func findCountry(withName name: String){
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
            let location = LocationHelper.getTappedLocation(mapView: mapView, gestureRecognizer: gestureRecognizer)
            let annotation = LocationHelper.makeAnnotation(withTitle: "You created this annotation!", coordinates: location)
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)

            cardinalPoints = CardinalPoints(originalLocation: location)
            
            WeatherAPIManager.getWeather(route: .fetchWeatherData(lat: location.latitude.toString, lon: location.longitude.toString, exclude: "daily", appId: Constants.appID)) { weather in
                
                
            } errorBlock: { error in
                print(error)
            }

            
            let list = [LocationHelper.makeAnnotation(withTitle: "North", coordinates: cardinalPoints.north),
                        LocationHelper.makeAnnotation(withTitle: "South", coordinates: cardinalPoints.south),
                        LocationHelper.makeAnnotation(withTitle: "East", coordinates: cardinalPoints.east),
                        LocationHelper.makeAnnotation(withTitle: "West", coordinates: cardinalPoints.west)]
            
            mapView.addAnnotations(list)
            
        }
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
        findCountry(withName: searchBar.text ?? "")
    }
    
}
