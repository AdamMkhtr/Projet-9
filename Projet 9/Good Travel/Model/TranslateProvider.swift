//
//  TranslateProvider.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 13/01/2021.
//

import Foundation

class TranslateProvider {

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  enum TranslateProviderError: LocalizedError {
    case dataError
    case responseError
    case decodeError
    case readError
  }

  //----------------------------------------------------------------------------
  // MARK: - Initialization
  //----------------------------------------------------------------------------

  private let apiKey: String
  private var session = URLSession(configuration: .default)

  init(apiKey: String = APIKeys.keyAPIGoogle,
       session: URLSession) {
    self.apiKey = apiKey
    self.session = session
  }

  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------

  /// Call the API google translate to collect data
  /// - Parameters:
  ///   - q: text to translate (name of the parameter)
  ///   - source: language to translate
  ///   - target: translation language
  ///   - completion: completion return the q translated
  func getTranslation(q: String , source: String = "fr", target: String = "en",
                      completion: @escaping ((String?, Error?) -> Void)) {
    let endpoint = "https://translation.googleapis.com/language/translate/v2"
    var url = URLComponents(string: endpoint)!
    url.queryItems = [
      URLQueryItem(name: "q", value: q),
      URLQueryItem(name: "source", value: source),
      URLQueryItem(name: "target", value: target),
      URLQueryItem(name: "format", value: "text"),
      URLQueryItem(name: "key", value: apiKey)
    ]

    var request = URLRequest(url: url.url!)
    request.httpMethod = "POST"

    let task = session.dataTask(with: request) { [weak self]
      (data, response, error) in

      guard let data = data, error == nil else {
        completion(nil, TranslateProviderError.dataError)
        print("Error translation API 1")
        return
      }
      guard let response = response as? HTTPURLResponse,
            response.statusCode == 200 else {
        completion(nil, TranslateProviderError.responseError)
        print("Error translation API 2")
        return
      }
      guard let json = try? JSONSerialization.jsonObject(
              with: data, options: []) as? [String:AnyObject] else {
        completion(nil, TranslateProviderError.decodeError)
        print("Error translation API 3")
        return
      }

      self?.exploiteDataTranslation(json: json) { (translation, error) in
        completion(translation, error)
      }
      
    }
    task.resume()
  }

  /// Open json data for collect the requested information
  /// - Parameters:
  ///   - json: json data of API call
  ///   - completion: return the requested information
  private func exploiteDataTranslation(json: [String:AnyObject],
                                       completion: @escaping
                                        ((String?, Error?) -> Void)) {
    guard let arrayOfTranalations = json["data"] as? [String: AnyObject] else {
      completion(nil, TranslateProviderError.readError)
      print("Error translation API 4")
      return
    }
    guard let translations =
            arrayOfTranalations["translations"] as? [[String: AnyObject]] else {
      completion(nil, TranslateProviderError.readError)
      print("Error translation API 5")
      return
    }
    guard let FinalTranslation = translations[0] as? [String: String] else {
      completion(nil, TranslateProviderError.readError)
      print("Error translation API 6")
      return
    }
    guard let textTranslated = FinalTranslation["translatedText"] else {
      completion(nil, TranslateProviderError.readError)
      print("Error translation API 7")
      return
    }
    completion(textTranslated, nil)
  }
}


