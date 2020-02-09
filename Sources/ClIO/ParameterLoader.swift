//
//  ParameterLoader.swift
//  clio
//
//  Created by Alex Apriamashvili on 08/02/2020.
//

import Foundation

final class InputParameterLoader<T: InputParameterKeyConstraint>: ParameterLoader {
  
  typealias ParameterKeyType = T
  
  private let argumentList: [String]
  private let argumentCount: Int32
  
  init(_ argv: [String], _ argc: Int32) {
    argumentList = argv
    argumentCount = argc
  }
  
  func load() -> Result<InputParameterMap<T>, InputError> {
    guard argumentCount > .zero else { return .failure(.emptyArgumentList) }
    guard argumentCount > 1 else { return emptyInput() }
    return parseArguments()
  }
}

private extension InputParameterLoader {
  
  func emptyInput() -> Result<InputParameterMap<T>, InputError> {
    return .success([T.empty: ""])
  }
  
  func isOption(_ argument: String) -> Bool {
    return argument.hasPrefix("-") || argument.hasPrefix("--")
  }
  
  func assign(value: String, for option: String, to map: inout InputParameterMap<T>) -> Bool {
    guard let key = T.init(value: option) else { return false }
    map[key] = value
    return true
  }
  
  func parseArguments() -> Result<InputParameterMap<T>, InputError> {
    let parameters = Array(argumentList.dropFirst())
    var parameterMap = InputParameterMap<T>()
    var parameterIndex = 1
    var index = 0
    while index < parameters.count {
      let argument = parameters[index]
      if isOption(argument) {
        if index < parameters.count - 1 {
          let nextItem = parameters[index + 1]
          if !isOption(nextItem) {
            index += 1
            guard assign(value: nextItem, for: argument, to: &parameterMap) else {
              return .failure(.unrecognizedParameter(argument))
            }
          } else {
            guard assign(value: "", for: argument, to: &parameterMap) else {
              return .failure(.unrecognizedParameter(argument))
            }
          }
        } else {
          guard assign(value: "", for: argument, to: &parameterMap) else {
            return .failure(.unrecognizedParameter(argument))
          }
          break
        }
      } else {
        let key = "\(parameterIndex)"
        guard assign(value: argument, for: key, to: &parameterMap) else {
          return .failure(.unrecognizedParameter(key))
        }
      }
      parameterIndex += 1
      index += 1
    }
    return .success(parameterMap)
  }
}
