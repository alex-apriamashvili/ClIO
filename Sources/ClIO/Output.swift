//
//  Output.swift
//  cli
//
//  Created by Alex Apriamashvili on 08/02/2020.
//

import Foundation

struct Output: CommandLineOutput {
  
  func writeMessage(_ message: String, to: OutputType) {
    switch to {
    case .standard:
      print("\(message)")
    case .warning:
      fputs("warning: \(message)\n", stderr)
    case .error:
      fputs("error: \(message)\n", stderr)
    }
  }
}
