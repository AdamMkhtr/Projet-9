//
//  Good_TravelTests.swift
//  Good TravelTests
//
//  Created by Adam Mokhtar on 08/12/2020.
//

import XCTest
@testable import Good_Travel

class TranslationAPITest: XCTestCase {
  
  func testGivenGetTranslation_WhenDataAndResponseIsNilButErrorIsFull_ThenReturnError() {
    
    let translateProvider = TranslateProvider(session : URLSessionFake(data: nil, response: nil, error: FakeResponseData.TranslateError.error))
    
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    translateProvider.getTranslation(q: "text", source: "text", target: "text") { (text, error) in
      
      XCTAssertNotNil(error)
      XCTAssertNil(text)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }
  
  func testGivenGetTranslation_WhenDataAndResponseAndErrorIsNil_ThenReturnError() {
    
    let translateProvider = TranslateProvider(session : URLSessionFake(data: nil, response: nil, error: nil))
    
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    translateProvider.getTranslation(q: "text", source: "text", target: "text") { (text, error) in
      
      XCTAssertNotNil(error)
      XCTAssertNil(text)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }
  
  func testGivenGetTranslation_WhenDataIsInccorectAndResponseIsNotOkAndErrorIsNil_ThenReturnError() {
    
    let translateProvider = TranslateProvider(session : URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseIsNotOk, error: nil))
    
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    translateProvider.getTranslation(q: "text", source: "text", target: "text") { (text, error) in
      
      XCTAssertNotNil(error)
      XCTAssertNil(text)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }
  
  func testGivenGetTranslation_WhenDataIsInccorectAndResponseIsOkAndErrorIsNil_ThenReturnError() {
    
    let translateProvider = TranslateProvider(session : URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseIsOk, error: nil))
    
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    translateProvider.getTranslation(q: "text", source: "text", target: "text") { (text, error) in
      
      XCTAssertNotNil(error)
      XCTAssertNil(text)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }
  
  
  func testGivenGetTranslation_WhenDataIsCorrectAndResponseIsOkAndErrorIsNil_ThenReturnTranslationAndTheDataIsCorrect() {
    
    let translateProvider = TranslateProvider(session : URLSessionFake(data: FakeResponseData.translateCorrectData, response: FakeResponseData.responseIsOk, error: nil))
    
    let expectation = XCTestExpectation(description: "Wait for queue change.")
    translateProvider.getTranslation(q: "text", source: "text", target: "text") { (translation, error) in
      
      XCTAssertNotNil(translation)
      XCTAssertNil(error)
      
      let translationCheck = "Hello"
      XCTAssertEqual(translationCheck, translation)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 0.01)
  }

  //----------------------------------------------------------------------------
  // MARK: - test Translate Converter
  //----------------------------------------------------------------------------

  func testGivenGetTranslation_WhenDataIsNill_ThenReturnError() {
    let session = URLSessionFake(data: nil,
                                 response: FakeResponseData.responseIsOk,
                                 error: nil)
    let translateConverter = TranslateConverter(with: session)
    translateConverter.convert(source: "FR", target: "ESP", originalText: "") { (text, error) in
      XCTAssertNil(text)
      XCTAssertNotNil(error)

    }
  }

  func testGivenGetTranslation_WhenOriginalTextIsOk_ThenReturnTranslation() {
    let session = URLSessionFake(data: FakeResponseData.translateCorrectData,
                                 response: FakeResponseData.responseIsOk,
                                 error: nil)
    let translateConverter = TranslateConverter(with: session)
    translateConverter.convert(source: "FR", target: "ESP", originalText: "Hello") { (text, error) in
      XCTAssertNil(error)
      XCTAssertNotNil(text)

    }
  }
  
}
