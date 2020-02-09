# ClIO

Command Line Input & Output library

==== README IS UNDER DEVELOPMENT ===

### Example Usage

#### Input
To create input, `ClIO` shall be told about the values that could be expected in that input.  
For example, in case if the program expects to recieve parameters such as `-l` – for local path and `-r` for a URL, the input could be describes as: 
```swift

/// option key description
enum ExampleOption: String, InputParameterKeyConstraint {
  case local = "-l"
  case remote = "-r"
  case none
  
  init?(rawValue: String) {
    switch rawValue {
      case "-l": self = .local
      case "-r": self = .remote
      default: return nil
    }
  }
  
  init?(value: String) {
    self.init(rawValue: value)
  }
  
  var value: String {
    rawValue
  }
  
  static var empty: ExampleOption = .none
}
```
When input is defined, it can be prapagated as a type that `ClIO` can try to populate from the arguments it recieves:
```swift
// `CommandLine.arguments` contains ["cmd", "-r", "./path/to/local/resource.ext"]
let inputReader = Assembly<ExampleOption>.assembleInput(CommandLine.arguments, CommandLine.argc)
```
Once the reader is assembled, it can provide all the parameters loaded from `argv`, which means that you can build your logic over recieving each of those parameters:
```swift
inputReader.inputParameters.forEach {
  switch $0.key {
  case .local:
    // handle local recource at `$0.value`
  case .remote:
    // handle remote resource at `$0.value`
  }
}
```
#### Output
`ClIO` can print regular log messages as well as warning and error ones. Both warning and error messages will be written to `stderr`.  
To assemble output, simply use the following expression:
```swift
let outputWriter = assembleOutput<_>.assembleOutput()
```
Once you have the outpur you can write your messages to either `stdout` or `stderr`.    
To write an error, use:
```swift
outputWriter.writeMessage("Whoa! Something went wrong. We'll all gonna die!", to: .error)
```
To write a regular output/log message use:
```swift
outputWriter.writeMessage("Your mind is like a parachute: If it isn’t open, it doesn’t work.")
```
