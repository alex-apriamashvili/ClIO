//
//  Output.swift
//  clio
//
//  Created by Alex Apriamashvili on 08/02/2020.
//

import Foundation

struct Output: CommandLineOutput {
  
  @discardableResult
  func writeMessage(_ message: String, to: OutputType) -> String {
    let formatted: String
    let out: UnsafeMutablePointer<FILE>
    switch to {
    case .standard:
      formatted = "\(message)\n"
      out = stdout
    case .warning:
      formatted = "warning: \(message)\n"
      out = stderr
    case .error:
      formatted = "error: \(message)\n"
      out = stderr
    }
    fputs(formatted, out)
    return formatted
  }
}
