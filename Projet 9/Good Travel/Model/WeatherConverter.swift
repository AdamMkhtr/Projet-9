//
//  WeatherConverteur.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 22/01/2021.
//

import Foundation

class WeatherConverter {

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  struct WeatherResult {
    let name: String
    let description: String
    let temperature: String
  }

  struct Localisation {
    let longitude: Double
    let latitude: Double
  }

  struct WeatherConverterResult {
    let source: WeatherResult
    let destination: WeatherResult
  }

  let destinationLocalisation = Localisation(longitude: -74.006,
                                             latitude: 40.7143)

  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  enum WeatherProviderError: Error {
    case dataError
    case invalidSourceLocalisation
  }

  //----------------------------------------------------------------------------
  // MARK: - Initialization
  //----------------------------------------------------------------------------

  private let weatherProvider :  WeatherProvider

  init(with session: URLSession = URLSession(configuration: .default)) {
    weatherProvider = WeatherProvider(session: session)
  }
  
  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------

  /// Use "GetWeather" for two localisation and return the requested information
  /// - Parameters:
  ///   - sourceLocalisation: Source localisation
  ///   - completion: return temperature, description and name of the city for two localisation
  func getWeathers(sourceLocalisation: Localisation, completion: @escaping
                    ((WeatherConverterResult?, Error?) -> Void)) {

    self.getWeather(loalisation: sourceLocalisation) { [weak self]
      (sourceResult, sourceError) in
      if let error = sourceError {
        completion(nil, error)
      }
      guard let destinationLocalisation = self?.destinationLocalisation else {
        completion(nil, WeatherProviderError.invalidSourceLocalisation)
        return
      }
      self?.getWeather(loalisation: destinationLocalisation) {
        (destinationResult, destinationError) in
        if let error = destinationError {
          completion(nil, error)
        }
        guard let sourceResult = sourceResult else {
          return
        }
        guard let destinationResult = destinationResult else {
          return
        }
        let result = WeatherConverterResult(source: sourceResult,
                                            destination: destinationResult)
        completion(result, nil)

      }
    }
  }

  /// Retrieve the information of weather API
  /// - Parameters:
  ///   - originalText: original text before translate
  ///   - completion: return error if the fun have any problem, otherwise return the value translated
  private  func getWeather(
    loalisation: Localisation,
    completion: @escaping ((WeatherResult?, Error?) -> Void)
  ) {
    weatherProvider.getWeather(longitude: String(loalisation.longitude),
                               latitude: String(loalisation.latitude)) {
      (name, description, temperature, error) in
      if let error = error {
        completion(nil, error)
      }
      guard let description = description else {
        completion(nil, WeatherProviderError.dataError)
        return
      }
      guard let temperature = temperature else {
        completion(nil, WeatherProviderError.dataError)
        return
      }
      guard let name = name else {
        completion(nil, WeatherProviderError.dataError)
        return
      }
      let temperatureString = String(temperature) + " °C"
      let result = WeatherResult(name: name, description: description,
                                 temperature: temperatureString)
      completion(result, nil)
    }
  }
}
