//
//  OutputTests.swift
//  ClIOTests
//
//  Created by Alexander Dupree on 15/02/2020.
//

import XCTest
@testable import ClIO

final class OutputTests: XCTestCase {

  private var sut: Output!
  private let stubMessage = "com.alex.apriamashvili.clio.stub.message"
  
  override func setUp() {
    super.setUp()
    sut = Output()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testStandardOutput() {
    let result = sut.writeMessage(stubMessage, to: .standard)
    XCTAssertEqual("\(stubMessage)\n", result)
  }
  
  func testStandardOutputShortcut() {
    let result = sut.writeMessage(stubMessage)
    XCTAssertEqual("\(stubMessage)\n", result)
  }
  
  func testWarningOutputDistinction() {
    let result = sut.writeMessage(stubMessage, to: .warning)
    XCTAssert(result.hasPrefix("warning:"))
    XCTAssert(result.contains(stubMessage))
    XCTAssert(result.hasSuffix("\n"))
  }
  
  func testErrorOutputDistinction() {
    let result = sut.writeMessage(stubMessage, to: .error)
    XCTAssert(result.hasPrefix("error:"))
    XCTAssert(result.contains(stubMessage))
    XCTAssert(result.hasSuffix("\n"))
  }
}
