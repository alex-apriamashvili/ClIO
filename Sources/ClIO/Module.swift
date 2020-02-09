
// MARK: - Public

public protocol InputParameterKeyConstraint: Hashable {
  
  init?(value: String)
  
  var value: String { get }
  
  static var empty: Self { get }
}

public enum InputError: Error, Equatable {
  case emptyArgumentList, unrecognizedParameter(String)
}

public protocol CommandLineInput {
  
  associatedtype ParameterKeyType: InputParameterKeyConstraint
  
  typealias InputParameterList<K: InputParameterKeyConstraint> =  [(key: K, value:String)]
  
  var inputParameters: InputParameterList<ParameterKeyType> { get }
}

public enum OutputType {
  case error, warning, standard
}

public protocol CommandLineOutput {
  
  func writeMessage(_ message: String, to: OutputType)
}

extension CommandLineOutput {
  
  func writeMessage(_ message: String) {
    writeMessage(message, to: .standard)
  }
}

public typealias CLIO = CommandLineInput & CommandLineOutput


// MARK: - Internal

protocol ParameterLoader {
  
  associatedtype ParameterKeyType: InputParameterKeyConstraint
  
  typealias InputParameterMap<K: InputParameterKeyConstraint> =  [K: String]
  
  init(_ argv: [String], _ argc: Int32)
  
  func load() -> Result<InputParameterMap<ParameterKeyType>, InputError>
}
