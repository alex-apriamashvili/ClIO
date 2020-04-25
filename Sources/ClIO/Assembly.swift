//
//  Assembly.swift
//  clio
//
//  Created by Alex Apriamashvili on 08/02/2020.
//

import Foundation

/// Command line Inpput and Output assembly
///
/// - assembles command line `Input` container, that includes parsed input parameters recieved by the consumer.
/// - assembles command line `Output` capable of writing information into `stdout` and `stderr`.
public struct Assembly {
  
  /// assemble `Command Line Input` container
  ///
  /// - Parameters:
  ///   - argv: a list of argumets received by the consumer
  ///   - argc: total number of arguments recieved y the consumer
  ///   - optionType: data type that describes input parameters expected by the consumer
  ///
  ///- returns: an instance of  the container that holds mapped `Command Line Input` arguments
  public static func assembleInput<I: InputParameterKeyConstraint>(_ argv: [String],
                                                                   _ argc: Int32,
                                                                   optionType: I.Type) -> Input<I> {
    let loader = InputParameterLoader<I>.init(argv, argc)
    return Input<I>(loader)
  }
  
  /// assemble `Command Line Output` writer
  ///
  /// this entity is capable of writing messages into `stdout` and `stderr` file descriptors.
  ///
  /// - returns: an entity of `Command Line Output` writer
  public static func assembleOutput() -> CommandLineOutput {
    return Output()
  }
}
