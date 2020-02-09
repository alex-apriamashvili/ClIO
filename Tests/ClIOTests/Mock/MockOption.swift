//
//  MockOption.swift
//  clio
//
//  Created by Alex Apriamashvili on 09/02/2020.
//

import ClIO

enum MockOption: Equatable {
  case none
  case help
  case force
  case fileLocation
  case generic(Int)
}

extension MockOption: RawRepresentable, InputParameterKeyConstraint {
  
  var rawValue: String {
    switch self {
    case let .generic(number):
      return "\(number)"
    default:
      return "\(self)"
    }
  }
  
  static var empty: MockOption = .none
  
  init?(rawValue: String) {
    switch rawValue {
    case Opt.help.short, Opt.help.long:
      self = .help
    case Opt.force.short, Opt.force.long:
      self = .force
    case Opt.fileLocation.short, Opt.fileLocation.long:
      self = .fileLocation
    default:
      guard let orderedNumber = Int(rawValue) else { return nil }
      self = .generic(orderedNumber)
    }
  }
  
  init?(value: String) {
    self.init(rawValue: value)
  }
  
  var value: String {
    return rawValue
  }
  
  struct Opt {
    
    let short: String
    let long: String
    
    static let help = Opt(short: "-h", long: "--help")
    static let force = Opt(short: "-f", long: "--force")
    static let fileLocation = Opt(short: "-F", long: "--file")
  }
}

