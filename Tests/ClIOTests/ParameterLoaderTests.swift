//
//  ParameterLoaderTests.swift
//  clioTests
//
//  Created by Alex Apriamashvili on 09/02/2020.
//

import XCTest
import XCTAssertResult

@testable import ClIO

final class ParameterLoaderTests: XCTestCase {

  func testEmptyArgumentListShallBeFaulty() {
    let sut = InputParameterLoader<MockOption>([], 0)
    let result = sut.load()
    XCTAssertResultEqual(InputError.emptyArgumentList, result)
  }
  
  func testSingleArgumentShallResultInEmptyParameters() {
    let sut = InputParameterLoader<MockOption>([C.cmd], 1)
    let result = sut.load()
    XCTAssertResultEqual([MockOption.empty: ""], result)
  }
  
  func testUnrecognizedOptionShallBeFaulty() {
    let sut = InputParameterLoader<MockOption>([C.cmd, "--verbose"], 2)
    let result = sut.load()
    XCTAssertResultEqual(InputError.unrecognizedParameter("--verbose"), result)
  }
  
  func testSingleFlagShouldSuccess() {
    let sut = InputParameterLoader<MockOption>([C.cmd, "--force"], 2)
    let result = sut.load()
    XCTAssertResultEqual([MockOption.force: ""], result)
  }
  
  func testTwoSequentialFlagsShouldSuccess() {
    let sut = InputParameterLoader<MockOption>([C.cmd, "--force", "--help"], 3)
    let result = sut.load()
    XCTAssertResultEqual([MockOption.force: "", MockOption.help: ""], result)
  }
  
  func testOptionAndValueShouldSuccess() {
    let sut = InputParameterLoader<MockOption>([C.cmd, "-F", "./path/to/smth"], 3)
    let result = sut.load()
    XCTAssertResultEqual([MockOption.fileLocation: "./path/to/smth"], result)
  }
  
  func testUnnamedValueShouldSuccess() {
    let sut = InputParameterLoader<MockOption>([C.cmd, "./path/to/smth"], 3)
    let result = sut.load()
    let expectedResult = [MockOption.generic(1): "./path/to/smth"]
    XCTAssertResultEqual(expectedResult, result)
  }
  
  func testMultipleUnnamedValuesShouldSuccess() {
    let sut = InputParameterLoader<MockOption>([C.cmd, "./path/to/smth", "./path/to/smth/else"], 3)
    let result = sut.load()
    let expectedResult = [
      MockOption.generic(1): "./path/to/smth",
      MockOption.generic(2): "./path/to/smth/else"
    ]
    XCTAssertResultEqual(expectedResult, result)
  }
  
  func testMixedArgumentsWithLeadingOptionShouldSuccess() {
    let sut = InputParameterLoader<MockOption>([C.cmd, "--file", "./path/to/smth", "./path/to/smth/else"], 4)
    let result = sut.load()
    let expectedResult = [
      MockOption.fileLocation: "./path/to/smth",
      MockOption.generic(2): "./path/to/smth/else"
    ]
    XCTAssertResultEqual(expectedResult, result)
  }
  
  func testMixedArgumentsWithLeadingValuesShouldSuccess() {
    let sut = InputParameterLoader<MockOption>([C.cmd, "./path/to/smth", "./path/to/smth/else", "--force"], 4)
    let result = sut.load()
    let expectedResult = [
      MockOption.generic(1): "./path/to/smth",
      MockOption.generic(2): "./path/to/smth/else",
      MockOption.force: ""
    ]
    XCTAssertResultEqual(expectedResult, result)
  }
}

private struct C {
  static let cmd = "cmd"
}
