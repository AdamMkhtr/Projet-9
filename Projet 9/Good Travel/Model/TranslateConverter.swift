//
//  TranslateConverter.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 13/01/2021.
//

import Foundation

class TranslateConverter {
  
  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------
  
  enum TranslateConverterError: Error {
    case dataError
  }
  
  //----------------------------------------------------------------------------
  // MARK: - Initialization
  //----------------------------------------------------------------------------
  
  private let translateProvider : TranslateProvider
  
  init(with session: URLSession = URLSession(configuration: .default)) {
    translateProvider = TranslateProvider(session: session)
  }
  
  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------
  
  /// Translate the orginal text whith the api call
  /// - Parameters:
  ///   - originalText: original text before translate
  ///   - completion: return error if the fun have any problem, otherwise return the value translated
  func convert(source: String, target: String, originalText: String,
               completion: @escaping ((String?, Error?) -> Void)) {
    translateProvider.getTranslation(
      q: originalText, source: source, target: target) { (text, error) in
      if let error = error {
        completion(nil, error)
      }
      guard let text = text else {
        completion(nil, TranslateConverterError.dataError)
        return
      }
      completion(text, nil)
    }
  }
}
