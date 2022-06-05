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
