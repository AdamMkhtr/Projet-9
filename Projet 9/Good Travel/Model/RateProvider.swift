//
//  MoneyConversion.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 09/12/2020.
//

import Foundation

class RateProvider {

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  /// Convert format date to be in agreement with the api
  var updateDate: String {
    let yesterday = Date().advanced(by: -86400)
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd"
    let dateOfYesterday = formater.string(from: yesterday)
    return dateOfYesterday
  }

  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  enum RateProviderError: LocalizedError {
    case dataError
    case responseError
    case decodeError
    case historicalError
    case readError

    var errorDescription: String? {
      switch self {
      case .dataError: return "error data is empty"
      case .decodeError: return "error decode"
      case .historicalError: return "error historical"
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

  init(apiKey: String = APIKeys.keyAPIRate,
       session : URLSession) {
    self.apiKey = apiKey
    self.session = session
  }

  //----------------------------------------------------------------------------
  // MARK: - Function
  //----------------------------------------------------------------------------

  /// Call the API fixer and check if we have good response
  /// - Parameters:
  ///   - base: base currency
  ///   - symbols:currency to convert
  ///   - completion: completion return the rate between currency
  func getRates(symbols: String, completion:
                  @escaping ((Double?, Error?) -> Void)) {
    let endpoint = "http://data.fixer.io/api/\(updateDate)"
    var url = URLComponents(string: endpoint)!
    url.queryItems = [
      URLQueryItem(name: "base", value: "EUR"),
      URLQueryItem(name: "symbols", value: symbols),
      URLQueryItem(name: "access_key", value: apiKey)
    ]
    var request = URLRequest(url: url.url!)
    request.httpMethod = "GET"

    let task = session.dataTask(with: request) { [weak self] (data,
                                                              response,
                                                              error) in

      guard let data = data, error == nil else{
        completion(nil, RateProviderError.dataError)
        print("error 1 rate")
        return
      }
      guard let response = response as? HTTPURLResponse,
            response.statusCode == 200 else {
        completion(nil, RateProviderError.responseError)
        print("error 2 rate")
        return
      }
      self?.exploiteDataRate(symbols: symbols, data: data) { (rate, error) in
        completion(rate, error)
      }
    }
    task.resume()
  }

  /// Debunk the data for retrieve the rate
  /// - Parameters:
  ///   - data: Data of api call
  ///   - completion: completion return the rate between currency
  private func exploiteDataRate(symbols : String, data: Data, completion:
                                  @escaping ((Double?, Error?) -> Void)) {
    guard let json = try? JSONSerialization.jsonObject(with: data, options: [])
            as? [String:AnyObject] else {
      completion(nil, RateProviderError.decodeError)
      print("error 3 rate")
      return
    }
    guard let success = json["success"] as? Bool else {
      completion(nil, RateProviderError.historicalError)
      print("error 4 rate")
      return
    }
    print(success)
    guard let rate = json["rates"] as? [String: Double] else {
      completion(nil, RateProviderError.readError)
      print("error 5 rate")
      return
    }
    guard let value = rate[symbols] else {
      completion(nil, RateProviderError.readError)
      print("error 6 rate")
      return
    }
    completion(value, nil)
  }

}
