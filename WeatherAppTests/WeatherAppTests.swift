//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by mohammad suhail on 4/6/22.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {

    var weather: Weather?
    var requestSuccess = false

    func testWeatherInformation(){
        let pred = NSPredicate(format: "weather != nil")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        WeatherAPIManager.getWeather(route: .fetchWeatherData(lat: "43.94131296851632", lon: "-1.381951168714238", exclude: "daily,minutely,alert", appId: Constants.appID)) { weather in
            self.weather = weather
            self.requestSuccess = true
            exp.fulfill()
        } errorBlock: { error in
            self.requestSuccess = false
        }

        let res = XCTWaiter.wait(for: [exp], timeout: 5.0)

        if res == XCTWaiter.Result.completed {
            guard let weather = weather else {
                XCTAssert(false, "weather is nil")
                return
            }
            XCTAssertTrue(requestSuccess)
            
            XCTAssertNotNil(weather.current, "Current weather data is nil")
            XCTAssertNotNil(weather.current?.temp, "The current weather temprature is nil")
            XCTAssertNotNil(weather.current?.humidity, "The current weather humidity is nil")
            XCTAssertNotNil(weather.current?.windSpeed, "The current weather wind speed is nil")

        } else {
            XCTAssert(false, res.debugDescription)
        }
    }

}

extension XCTWaiter.Result: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .completed:
            return "Completed"
        case .incorrectOrder:
            return "Incorrect Order"
        case .interrupted:
            return "Interrupted"
        case .invertedFulfillment:
            return "Inverted Fulfillment"
        case .timedOut:
            return "Timed Out"
        @unknown default:
            fatalError("Unknown XCTWaiter.Result case")
        }
    }
}
