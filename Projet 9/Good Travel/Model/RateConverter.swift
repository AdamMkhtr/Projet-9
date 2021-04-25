//
//  RateConverter.swift
//  Good Travel
//
//  Created by Adam Mokhtar on 14/12/2020.
//

import Foundation

class RateConverter {

  //----------------------------------------------------------------------------
  // MARK: - Properties
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // MARK: - Error Management
  //----------------------------------------------------------------------------

  enum RateConterError: Error {
    case invalidRate
    case invalidEuro
    case negativeExpression
    case longExpression
    case invalidCuerrency
  }

  //----------------------------------------------------------------------------
  // MARK: - Initialization
  //----------------------------------------------------------------------------

  private let provider: RateProvider

  init(with session: URLSession = URLSession(configuration: .default)) {
    provider = RateProvider(session: session)
  }

  //----------------------------------------------------------------------------
  // MARK: - Method
  //----------------------------------------------------------------------------

  /// Compute the convert with the rate of the result of api for the value of the user
  /// - Parameters:
  ///   - euro: value to convert
  ///   - completion: return error if the fun have any problem, otherwise return the value calculated
  func convert(euro: String, resultCuerrency: String, completion: @escaping
                ((String?, Error?) -> Void)) {
    provider.getRates(symbols: resultCuerrency) { (rate, error) in

      guard let rate = rate else {
        completion(nil, RateConterError.invalidRate)
        return
      }
      guard let euro = Double(euro) else {
        completion(nil, RateConterError.invalidEuro)
        return
      }
      guard euro > 0 else {
        completion(nil, RateConterError.negativeExpression)
        return
      }
      guard euro < 100000 else {
        completion(nil, RateConterError.longExpression)
        return
      }

      let resultCompute = rate * euro
      let result = String(format: "%.2f", resultCompute)
      completion(result, nil)
    }
  }
}
