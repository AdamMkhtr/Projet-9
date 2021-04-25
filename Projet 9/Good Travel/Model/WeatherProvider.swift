//
//  WeatherProvider.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 22/01/2021.
//

import Foundation

class WeatherProvider {

  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  enum WeatherProviderError: LocalizedError {
    case dataError
    case responseError
    case decodeError
    case readError

    var errorDescription: String? {
      switch self {
      case .dataError: return "error data is empty"
      case .decodeError: return "error decode"
      case .readError: return "read the array of rate error"
      case .responseError: return "bad code response"
      }
    }
  }

  //----------------------------------------------------------------------------
  // MARK: - Initialization
  //----------------------------------------------------------------------------
  private let apiKey: String
  private var session = URLSession(configuration: .default)

  init(apiKey: String = APIKeys.keyAPIWeather,
       session : URLSession) {
    self.apiKey = apiKey
    self.session = session
  }

  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------

  /// Call the API weather and check if we have good response
  /// - Parameters:
  ///   - base: base currency
  ///   - symbols:currency to convert
  ///   - completion: completion return the rate between currency
  func getWeather(
    longitude: String,
    latitude: String,
    completion: @escaping ((String?, String?, Double?, Error?) -> Void)
  ) {
    let endpoint = "http://api.openweathermap.org/data/2.5/weather/"
    var url = URLComponents(string: endpoint)!
    url.queryItems = [
      URLQueryItem(name: "units", value: "metric"),
      URLQueryItem(name: "lon", value: longitude),
      URLQueryItem(name: "lat", value: latitude),
      URLQueryItem(name: "lang", value: "fr"),
      URLQueryItem(name: "appid", value: apiKey)
    ]
    var request = URLRequest(url: url.url!)
    request.httpMethod = "GET"

    let task = session.dataTask(with: request) { [weak self]
      (data, response, error) in

      guard let data = data, error == nil else{
        completion(nil, nil, nil, WeatherProviderError.dataError)
        return
      }
      guard let response = response as? HTTPURLResponse,
            response.statusCode == 200 else {
        completion(nil, nil, nil, WeatherProviderError.responseError)
        return
      }
      self?.exploiteDataWeather(data: data) { (name, description,
                                               temperature, error) in
        completion(name, description, temperature, error)
      }
    }
    task.resume()
  }

  /// Debunk the data for retrieve the information of weather
  /// - Parameters:
  ///   - data: Data of api call
  ///   - completion: completion return the rate between currency
  private func exploiteDataWeather(
    data: Data,
    completion: @escaping ((String?, String?, Double?, Error?) -> Void)
  ) {
    guard let json = try? JSONSerialization.jsonObject(with: data, options: [])
            as? [String:AnyObject] else {
      completion(nil, nil, nil, WeatherProviderError.decodeError)
      print("Error Weather API 1")
      return
    }
    guard let weatherData = json["weather"] as? [[String: AnyObject]] else {
      completion(nil, nil, nil, WeatherProviderError.readError)
      print("Error Weather API 2")
      return
    }
    guard let description = weatherData.first?["description"] as? String else {
      completion(nil, nil, nil, WeatherProviderError.readError)
      print("Error Weather API 3")
      return
    }

    print(description)
    guard let temperatureData = json["main"] as? [String: Double] else {
      completion(nil, nil, nil, WeatherProviderError.readError)
      print("Error Weather API 4")
      return
    }
    guard let temperature = temperatureData["temp"] else {
      completion(nil, nil, nil, WeatherProviderError.readError)
      print("Error Weather API 5")
      return
    }
    print(temperature)
    guard let name = json["name"] as? String else {
      completion(nil, nil, nil, WeatherProviderError.readError)
      print("Error Weather API 6")
      return
    }
    completion(name, description, temperature, nil)
  }
}
