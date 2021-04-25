//
//  WeatherAPITest.swift
//  Good TravelTests
//
//  Created by Adam Mokhtar on 24/03/2021.
//

import XCTest
@testable import Good_Travel

class WeatherAPITest: XCTestCase {

  func testGivenGetWeather_WhenDataAndResponseIsNilButErrorIsFull_ThenReturnError() {

    let weatherProvider = WeatherProvider(session : URLSessionFake(data: nil, response: nil, error: FakeResponseData.TranslateError.error))
    
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    weatherProvider.getWeather(longitude: "", latitude: "") { (name, description, temperature, error) in

      XCTAssertNotNil(error)
      XCTAssertNil(name)
      XCTAssertNil(description)
      XCTAssertNil(temperature)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }

  func testGivenGetWeather_WhenDataAndResponseAndErrorIsNil_ThenReturnError() {

    let weatherProvider = WeatherProvider(session : URLSessionFake(data: nil, response: nil, error: nil))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    weatherProvider.getWeather(longitude: "", latitude: "") { (name, description, temperature, error) in

      XCTAssertNotNil(error)
      XCTAssertNil(name)
      XCTAssertNil(description)
      XCTAssertNil(temperature)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }

  func testGivenGetWeather_WhenDataIsInccorectAndResponseIsNotOkAndErrorIsNil_ThenReturnError() {

    let weatherProvider = WeatherProvider(session : URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseIsNotOk, error: nil))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    weatherProvider.getWeather(longitude: "", latitude: "") { (name, description, temperature, error) in

      XCTAssertNotNil(error)
      XCTAssertNil(name)
      XCTAssertNil(description)
      XCTAssertNil(temperature)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }

  func testGivenGetWeather_WhenDataIsInccorectAndResponseIsOkAndErrorIsNil_ThenReturnError() {

    let weatherProvider = WeatherProvider(session : URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseIsOk, error: nil))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    weatherProvider.getWeather(longitude: "", latitude: "") { (name, description, temperature, error) in

      XCTAssertNotNil(error)
      XCTAssertNil(name)
      XCTAssertNil(description)
      XCTAssertNil(temperature)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }

  func testGivenGetWeather_WhenDataIsCorrectAndResponseIsOkAndErrorIsNil_ThenReturnWeatherAndTheDataIsCorrect() {

    let weatherProvider = WeatherProvider(session : URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseIsOk, error: nil))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    weatherProvider.getWeather(longitude: "", latitude: "") { (name, description, temperature, error) in

      XCTAssertNil(error)
      XCTAssertNotNil(name)
      XCTAssertNotNil(description)
      XCTAssertNotNil(temperature)

      let nameCheck = "Londres"
      let descriptionCheck = "nuageux"
      let temperatureCheck = 11.07
      XCTAssertEqual(nameCheck, name)
      XCTAssertEqual(descriptionCheck, description)
      XCTAssertEqual(temperatureCheck, temperature)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }
  //----------------------------------------------------------------------------
  // MARK: - Test Weather Converter
  //----------------------------------------------------------------------------


  func testGivenGetWeather_WhenWeHaveLocation_ThenReturnWeatherData() {
    let session = URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                 response: FakeResponseData.responseIsOk,
                                 error: nil)
    let weatherConverter = WeatherConverter(with: session)
    weatherConverter.getWeathers(sourceLocalisation: weatherConverter.destinationLocalisation) { (dataWeathers, error) in
      XCTAssertNil(error)
      XCTAssertNotNil(dataWeathers)
    }
  }
}
