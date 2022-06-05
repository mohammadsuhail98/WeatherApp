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
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                print("This is nil")
                return
            }
            if let latitude = response.mapItems.first?.placemark.coordinate.latitude,
               let longitude = response.mapItems.first?.placemark.coordinate.longitude {
                self.setNewRegion(latitude: latitude, longitude: longitude)
            }
            
        }
    }
    
    func setNewRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees, regionRadius: CLLocationDistance = 200000){
        let newCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let newRegion = MKCoordinateRegion(center: newCoordinates, latitudinalMeters: 200000, longitudinalMeters: 200000)
        self.mapView.setRegion(newRegion, animated: true)
    }
    
    @objc func addAnnotation(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == .began {
            let location = getTappedLocation(mapView: mapView, gestureRecognizer: gestureRecognizer)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "You created this annotation!"
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)
        }
    }
    
    func getTappedLocation(mapView: MKMapView, gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D{
        let touchPoint = gestureRecognizer.location(in: mapView)
        return mapView.convert(touchPoint, toCoordinateFrom: mapView)
    }
    
    func addOnUserTapAction(mapView: MKMapView, target: AnyObject, action: Selector, tapDuration: Double = 1){
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
