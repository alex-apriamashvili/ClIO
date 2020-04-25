//
//  Module.swift
//  clio
//
//  Created by Alex Apriamashvili on 08/02/2020.
//

// MARK: - Public (Input)

/// a protocol that represents an entity that could describe a single option passed as an argument in a command line
///
/// Example:
///
///   In a situation where the following arguments were specified for `consumer-cli`:
///  ```
///  $ consumer-cli --foo bar
///  ```
///  `--foo` option is most likely to be represented by this protocol
///
public protocol InputParameterKeyConstraint: Hashable {
  
  /// required initializer for the entity
  /// - parameter value: a string representation that the entity can be described with
  init?(value: String)
  
  /// string representation of the entity
  var value: String { get }
  
  /// a variable that represents an empty state of the entity
  /// could be applied in a situation when option is not set
  static var empty: Self { get }
}

/// An enum that contains errors that are expected to be returned by `ClIO`
public enum InputError: Error, Equatable {
  /// the argument list reciever is completely empty (receiver was not specified)
  case emptyArgumentList
  
  /// unexpected parameter was encountered while parsing the input
  case unrecognizedParameter(String)
}

/// a protocol that describes `Command Line Input` container
public protocol CommandLineInput {
  
  /// a key type constrained by the option key type provided by the receiver
  associatedtype ParameterKeyType: InputParameterKeyConstraint
  
  /// list of input parameter tuples
  /// one tuple represents a pair of `option <-> parameter`
  typealias InputParameterList<K: InputParameterKeyConstraint> =  [(key: K, value:String)]
  
  /// a list of loaded input parameters
  var inputParameters: InputParameterList<ParameterKeyType> { get }
}

// MARK: - Public (Output)

/// an enum that describes `Output` options available
public enum OutputType {
  
  /// adds `error:` prefix to the message and redirects output to `stderr`
  case error
  
  /// adds `warning:` prefix and redirects output to `stderr`
  case warning
  
  /// redirects output to `stdout`
  case standard
}

/// a protocol that describes an entity responsible for `Command Line Output` writing
public protocol CommandLineOutput {
  
  /// write message to the specified `OutputType`
  ///
  /// - Parameters:
  ///   - message: a message that needs to be printed out
  ///   - to: message `OutputType`
  /// - returns: string to be printed out (discardable)
  @discardableResult
  func writeMessage(_ message: String, to: OutputType) -> String
}

extension CommandLineOutput {
  
  @discardableResult
  public func writeMessage(_ message: String) -> String {
    return writeMessage(message, to: .standard)
  }
}

// MARK: - Internal

protocol ParameterLoader {
  
  associatedtype ParameterKeyType: InputParameterKeyConstraint
  
  typealias InputParameterMap<K: InputParameterKeyConstraint> =  [K: String]
  
  init(_ argv: [String], _ argc: Int32)
  
  func load() -> Result<InputParameterMap<ParameterKeyType>, InputError>
}
