//
//  Input.swift
//  cli
//
//  Created by Alex Apriamashvili on 08/02/2020.
//

import Foundation

public struct Input<T: InputParameterKeyConstraint>: CommandLineInput {
  
  public typealias ParameterKeyType = T
  
  private let loader: InputParameterLoader<T>
  
  public var inputParameters: InputParameterList<T> {
    return loadParams()
  }
  
  init(_ loader: InputParameterLoader<T>) {
    self.loader = loader
  }
  
  func loadParams() -> InputParameterList<T> {
    switch loader.load() {
    case let .success(parameterList):
      return parameterList
        .map{ (key: $0.key, value: $0.value) }
        .sorted(by: { $0.key.value < $1.key.value })
    case .failure(_):
      return []
    }
  }
}
