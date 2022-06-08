//
//  HighestStatsView.swift
//  WeatherApp
//
//  Created by mohammad suhail on 8/6/22.
//

import Foundation
import UIKit
import STPopup

class HighestStatsViewController: UIViewController {
 
    @IBOutlet var highestStatsLbls: [UILabel]!
    @IBOutlet var highestStatsImages: [UIImageView]!
    
    var highestTemp = Weather()
    var highestHum = Weather()
    var highestWindSpeed = Weather()
    var highestRain = Weather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setPopupSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillData(){
        let tempratureInfo = "Temprature \(highestTemp.current?.tempC.map{ "\($0)" } ?? "-")"
        self.highestStatsLbls[0].text = tempratureInfo
        self.highestStatsImages[0].image = tempratureInfo.contains("-") ? UIImage(named: "none") : UIImage(named: highestTemp.cardinalPoint?.title.lowercased() ?? "original")
        
        let humidityInfo = "Humidity \(highestHum.current?.humidity.map{ "\($0)" } ?? "-")"
        self.highestStatsLbls[1].text = humidityInfo
        self.highestStatsImages[1].image = humidityInfo.contains("-") ? UIImage(named: "none") : UIImage(named: highestHum.cardinalPoint?.title.lowercased() ?? "original")
        
        let windInfo = "Wind Speed \(highestWindSpeed.current?.windSpeed.map{ "\($0)" } ?? "-")"
        self.highestStatsLbls[2].text = windInfo
        self.highestStatsImages[2].image = windInfo.contains("-") ? UIImage(named: "none") : UIImage(named: highestWindSpeed.cardinalPoint?.title.lowercased() ?? "original")
        
        if let rain = highestRain.lastHourRain {
            self.highestStatsLbls[3].text = "Rain \(rain)"
            self.highestStatsImages[3].image = UIImage(named: highestRain.cardinalPoint?.title.lowercased() ?? "original")
        } else {
            self.highestStatsLbls[3].text = "Rain -"
            self.highestStatsImages[3].image = UIImage(named: "none")
        }
    }
    
    func setupUI(){
        self.view.layer.cornerRadius = 7
    }
    
    func setPopupSize() {
        contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width * 0.90, height: 260)
        landscapeContentSizeInPopup = CGSize(width: UIScreen.main.bounds.width * 0.85, height: 260)
    }
    
}

