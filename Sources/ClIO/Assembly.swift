//
//  Assembly.swift
//  cli
//
//  Created by Alex Apriamashvili on 08/02/2020.
//

import Foundation

public struct Assembly<I: InputParameterKeyConstraint> {
  
  public static func assembleInput(_ argv: [String], _ argc: Int32) -> Input<I> {
    let loader = InputParameterLoader<I>.init(argv, argc)
    return Input<I>(loader)
  }
  
  public static func assembleOutput() -> CommandLineOutput {
    return Output()
  }
}
