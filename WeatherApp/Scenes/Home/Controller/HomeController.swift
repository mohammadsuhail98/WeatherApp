//
//  ViewController.swift
//  WeatherApp
//
//  Created by mohammad suhail on 4/6/22.
//

import UIKit
import MapKit
import CoreLocation
import STPopup
import Actions

class HomeController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    fileprivate var viewModel: HomeViewModel?
    fileprivate var cardinalPoints = CardinalPoints()
    
    var highestTemp = Weather()
    var highestHum = Weather()
    var highestWindSpeen = Weather()
    var highestRainRate = Weather()
    var annotation = MKPointAnnotation()
    
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
        mapView.delegate = self
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
            annotation = LocationHelper.makeAnnotation(withTitle: "\(originalLocation.latitude) - \(originalLocation.longitude)", coordinates: originalLocation)
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)
            startFetchingForAllLocations(originalLocation: originalLocation)
        }
    }
    
    func startFetchingForAllLocations(originalLocation: CLLocationCoordinate2D){
        showHUD()
        viewModel?.locations.removeAll()
        viewModel?.locationCount = 0
        cardinalPoints = CardinalPoints(originalLocation: originalLocation)
        fetchWeatherData(withLocation: originalLocation)
        fetchWeatherData(withLocation: cardinalPoints.north, point: .north)
        fetchWeatherData(withLocation: cardinalPoints.south, point: .south)
        fetchWeatherData(withLocation: cardinalPoints.east, point: .east)
        fetchWeatherData(withLocation: cardinalPoints.west, point: .west)
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
    
    func showFinalData(weather: [Weather]){
        highestTemp = weather.filter({ $0.current?.highestTemp ?? false}).first ?? Weather()
        highestHum = weather.filter({ $0.current?.highestHumidity ?? false}).first ?? Weather()
        highestWindSpeen = weather.filter({ $0.current?.highestWindSpeed ?? false}).first ?? Weather()
        highestRainRate = weather.filter({ $0.current?.highestRainRate ?? false}).first ?? Weather()
        
        let highestWeatherStatsVC = HighestStatsViewController(nibName: "HighestStatsViewController", bundle: nil)
        highestWeatherStatsVC.highestTemp = highestTemp
        highestWeatherStatsVC.highestHum = highestHum
        highestWeatherStatsVC.highestWindSpeed = highestWindSpeen
        highestWeatherStatsVC.highestRain = highestRainRate
        
        showPopup(WithController: highestWeatherStatsVC)
    }
    
    func showPopup(WithController controller: UIViewController){
        let popup = STPopupController(rootViewController: controller)
        popup.style = .formSheet
        popup.setNavigationBarHidden(true, animated: false)
        popup.backgroundView?.addTap(action: { _ in
            self.mapView.deselectAnnotation(self.annotation, animated: true)
            popup.dismiss()
        })
        popup.containerView.backgroundColor = .clear
        popup.present(in: self)
    }

}

extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.showFinalData(weather: [highestTemp, highestHum, highestWindSpeen, highestRainRate])
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
        hideHUD()
        showFinalData(weather: weather)
    }
    
    func errorOccured(error: NSError) {
        hideHUD()
        if let message = error.userInfo["message"] as? String {
            self.presentAlert(title: "Sorry!", messsage: message)
        } else {
            self.presentAlert(title: "Sorry!", messsage: error.localizedDescription)
        }
    }
    
}
