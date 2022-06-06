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
        LocationHelper.findCountry(withName: name, mapView: self.mapView) { region in
            if let region = region {
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    @objc func addAnnotation(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == .began {
            let location = LocationHelper.getTappedLocation(mapView: mapView, gestureRecognizer: gestureRecognizer)
            let annotation = LocationHelper.makeAnnotation(withTitle: "You created this annotation!", coordinates: location)
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)

            let north = LocationHelper.destinationBy(coordinates: location, direction: .north).coordinate
            let south = LocationHelper.destinationBy(coordinates: location, direction: .south).coordinate
            let east = LocationHelper.destinationBy(coordinates: location, direction: .east).coordinate
            let west = LocationHelper.destinationBy(coordinates: location, direction: .west).coordinate

            let list = [LocationHelper.makeAnnotation(withTitle: "North", coordinates: north),
                        LocationHelper.makeAnnotation(withTitle: "South", coordinates: south),
                        LocationHelper.makeAnnotation(withTitle: "East", coordinates: east),
                        LocationHelper.makeAnnotation(withTitle: "West", coordinates: west),]
            
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
