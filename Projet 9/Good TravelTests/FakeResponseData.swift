//
//  FakeResponseData.swift
//  Good TravelTests
//
//  Created by Adam Mokhtar on 10/03/2021.
//

import Foundation
class FakeResponseData {

  //----------------------------------------------------------------------------
  // MARK: - Response URL
  //----------------------------------------------------------------------------

  static let responseIsOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
  static let responseIsNotOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!

  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  class TranslateError: Error {
    static let error = TranslateError()
  }

  //----------------------------------------------------------------------------
  // MARK: - Inccorect Data
  //----------------------------------------------------------------------------

  static let incorrectData = "erreur".data(using: .utf8)!

  //----------------------------------------------------------------------------
  // MARK: - Translation API Fake Data
  //----------------------------------------------------------------------------

  static  var translateCorrectData : Data? {
    let jsonText =
      """
{
"data": {
"translations": [
{
"translatedText": "Hello"
}
]
}
}
"""
    return jsonText.data(using: .utf8)
  }

  //----------------------------------------------------------------------------
  // MARK: - Weather API Fake Data
  //----------------------------------------------------------------------------

  static  var weatherCorrectData : Data? {
    let jsonText =

      """
{
    "coord": {
        "lon": -0.1257,
        "lat": 51.5085
    },
    "weather": [
        {
            "id": 803,
            "main": "Clouds",
            "description": "nuageux",
            "icon": "04d"
        }
    ],
    "base": "stations",
    "main": {
        "temp": 11.07,
        "feels_like": 6.05,
        "temp_min": 10,
        "temp_max": 12.22,
        "pressure": 1019,
        "humidity": 76
    },
    "visibility": 10000,
    "wind": {
        "speed": 6.17,
        "deg": 230
    },
    "clouds": {
        "all": 75
    },
    "dt": 1616680371,
    "sys": {
        "type": 1,
        "id": 1414,
        "country": "GB",
        "sunrise": 1616651489,
        "sunset": 1616696474
    },
    "timezone": 0,
    "id": 2643743,
    "name": "Londres",
    "cod": 200
}
"""
    return jsonText.data(using: .utf8)
  }




  //----------------------------------------------------------------------------
  // MARK: - Fake data Rate API
  //----------------------------------------------------------------------------

  static  var rateCorrectData : Data? {
    let jsonText =

      """
{
    "success": true,
    "timestamp": 1607471999,
    "historical": true,
    "base": "EUR",
    "date": "2020-12-08",
    "rates": {
        "USD": 1.210943
    }
}
"""
    return jsonText.data(using: .utf8)
  }
}

