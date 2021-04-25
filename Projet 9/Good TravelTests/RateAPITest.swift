//
//  RateAPITest.swift
//  Good TravelTests
//
//  Created by Adam Mokhtar on 25/03/2021.
//

import XCTest
@testable import Good_Travel

class RateAPITest: XCTestCase {

  func testGivenGetRate_WhenDataAndResponseIsNilButErrorIsFull_ThenReturnError() {

    let rateProvider = RateProvider(session : URLSessionFake(data: nil, response: nil, error: FakeResponseData.TranslateError.error))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    rateProvider.getRates(symbols: "") { (rate, error) in

      XCTAssertNotNil(error)
      XCTAssertNil(rate)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }

  func testGivenGetRate_WhenDataAndResponseAndErrorIsNil_ThenReturnError() {

    let rateProvider = RateProvider(session : URLSessionFake(data: nil, response: nil, error: nil))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    rateProvider.getRates(symbols: "") { (rate, error) in

      XCTAssertNotNil(error)
      XCTAssertNil(rate)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }

  func testGivenGetRate_WhenDataIsInccorectAndResponseIsNotOkAndErrorIsNil_ThenReturnError() {

    let rateProvider = RateProvider(session : URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseIsNotOk, error: nil))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    rateProvider.getRates(symbols: "") { (rate, error) in

      XCTAssertNotNil(error)
      XCTAssertNil(rate)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }

  func testGivenGetRate_WhenDataIsInccorectAndResponseIsOkAndErrorIsNil_ThenReturnError() {

    let rateProvider = RateProvider(session : URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseIsOk, error: nil))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    rateProvider.getRates(symbols: "") { (rate, error) in

      XCTAssertNotNil(error)
      XCTAssertNil(rate)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }


  func testGivenGetRate_WhenDataIsCorrectAndResponseIsOkAndErrorIsNil_ThenReturnRateAndTheDataIsCorrect() {

    let rateProvider = RateProvider(session : URLSessionFake(data: FakeResponseData.rateCorrectData, response: FakeResponseData.responseIsOk, error: nil))

    let expectation = XCTestExpectation(description: "Wait for queue change.")
    rateProvider.getRates(symbols: "USD") { (rate, error) in

      XCTAssertNil(error)
      XCTAssertNotNil(rate)

      let rateCheck = 1.210943
      XCTAssertEqual(rateCheck, rate)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }



  //----------------------------------------------------------------------------
  // MARK: - Test rate converter
  //----------------------------------------------------------------------------

  func testGivenGetRate_WhenDataIsNill_ThenReturnError() {
    let session = URLSessionFake(data: nil,
                                 response: FakeResponseData.responseIsOk,
                                 error: nil)
    let rateConverter = RateConverter(with: session)
    rateConverter.convert(euro: "100000000000000000000000", resultCuerrency: "USD") { (rate, error) in
      XCTAssertNil(rate)
      XCTAssertNotNil(error)
    }
  }

  func testGivenGetRate_WhenValueTooBig_ThenReturnError() {
    let session = URLSessionFake(data: FakeResponseData.rateCorrectData,
                                 response: FakeResponseData.responseIsOk,
                                 error: nil)
    let rateConverter = RateConverter(with: session)
    rateConverter.convert(euro: "100000000000000000000000", resultCuerrency: "USD") { (rate, error) in
      XCTAssertNil(rate)
      XCTAssertNotNil(error)
    }
  }


  func testGivenGetRate_WhenValueIsNotDouble_ThenReturnError() {
    let session = URLSessionFake(data: FakeResponseData.rateCorrectData,
                                 response: FakeResponseData.responseIsOk,
                                 error: nil)
    let rateConverter = RateConverter(with: session)
    rateConverter.convert(euro: "abc", resultCuerrency: "USD") { (rate, error) in
      XCTAssertNil(rate)
      XCTAssertNotNil(error)
    }
  }

  func testGivenGetRate_WhenValueIsNegativeDouble_ThenReturnError() {
    let session = URLSessionFake(data: FakeResponseData.rateCorrectData,
                                 response: FakeResponseData.responseIsOk,
                                 error: nil)
    let rateConverter = RateConverter(with: session)
    rateConverter.convert(euro: "-10", resultCuerrency: "USD") { (rate, error) in
      XCTAssertNil(rate)
      XCTAssertNotNil(error)
    }

  }

  func testGivenGetRate_WhenValueIsGood_ThenReturnRate() {
    let session = URLSessionFake(data: FakeResponseData.rateCorrectData,
                                 response: FakeResponseData.responseIsOk,
                                 error: nil)
    let rateConverter = RateConverter(with: session)
    rateConverter.convert(euro: "10", resultCuerrency: "USD") { (rate, error) in
      XCTAssertNil(error)
      XCTAssertNotNil(rate)
    }

  }
}


