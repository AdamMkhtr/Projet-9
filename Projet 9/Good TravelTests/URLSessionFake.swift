//
//  URLSessionFake.swift
//  Good TravelTests
//
//  Created by Adam Mokhtar on 14/03/2021.
//

import Foundation

class URLSessionFake: URLSession {

  //----------------------------------------------------------------------------
  // MARK: - Setup initializeur
  //----------------------------------------------------------------------------

    var data: Data?
    var response: URLResponse?
    var error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

  //----------------------------------------------------------------------------
  // MARK: - Override DataTask
  //----------------------------------------------------------------------------

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      let data = self.data
      let response = self.response
      let error = self.error
      return URLSessionDataTaskFake {
            completionHandler(data, response, error)
      }
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      let data = self.data
      let response = self.response
      let error = self.error
      return URLSessionDataTaskFake {
            completionHandler(data, response, error)
      }
    }
}


//----------------------------------------------------------------------------
// MARK: - Fake URLSessionDataTask
//----------------------------------------------------------------------------


class URLSessionDataTaskFake: URLSessionDataTask {
    var completionHandler: (() -> Void)?


  init(completionHandler: (() -> Void)?) {
      self.completionHandler = completionHandler
  }

    override func resume() {
        completionHandler?()
    }

    override func cancel() {}
}
