# ClIO
Command-Line Input & Output library

This library provides a simple and structured way of defining arguments that you expect to receive for your CLI as input and then work with those arguments in an easy manner. Also, this library provides a clear way of printing your messages to `stdout` and `stderr` file descriptors. 

### Usage
#### Input
There are 2 simple steps that you need to execute to start working with your command-line input more effectively:
##### 1. Set up your expectations
To make your work with command line arguments more convenient and systematic, there is a parameter constraint that needs to be defined on the consumer (CLI) side.

Imagine, that we expect 'foo' (`-F` or `--foo`) option to be passed through the command line\*.
###### Example:
```bash
$ your-cli --foo some-value
```
or
```bash
$ your-cli -F some-value
```
In that case, we need to define our expectation as the following:
```swift
enum ExampleOption: Equatable {
  case none
  case foo
}

extension ExampleOption: RawRepresentable, InputParameterKeyConstraint {  
  
  static var empty: ExampleOption = .none
  var rawValue: String { return "\(self)" }
  var value: String { return rawValue }
  
  init?(rawValue: String) {
    switch rawValue {
    case Opt.foo.short, Opt.foo.long:
      self = .foo
    }
  }
  
  init?(value: String) { self.init(rawValue: value) }
  
  struct Opt {
    let short: String
    let long: String
    
    static let foo = Opt(short: "-F", long: "--foo")
  }
}
```
Once we defined our expectation, we're ready to proceed to the step 2.

##### 2. Assemble Input container
To start using `ClIO.Input` simply call `Assembly` to build you an instance of the container.
```swift
let parametersContainer = ClIO.Assembly.assembleInput(
  CommandLine.arguments,
  CommandLine.argc,
  optionType: ExampleOption.self
)
```
Now you can build your logic over receiving these parameters.  
For example:
```swift
guard let firstParameter = parametersContainer.inputParameters.first else { return }
switch firstParameter.key {
case .none, .empty:
  // - no parameters were received, exiting with an error
  exit(1)
case .foo:
  // - foo option followed by a parameter was recieved
  exit(0)
default:
  return
}
```
#### Output
Using output is easy, all you need is to assemble an instance of that output.
```swift
let output = ClIO.Assembly.assembleOutput()
```
Now you can slightly enhance the logic that we have above by printing messages to the output:
```swift
guard let firstParameter = parametersContainer.inputParameters.first else { return }
switch firstParameter.key {
case .none, .empty:
  output.writeMessage("No parameters found", to: .error)
  exit(1)
case .foo:
  output.writeMessage("foo option was received with value: \(firstParameter.value)")
  exit(0)
default:
  return
}
```

### Installation
`ClIO` is distributed as an SPM package and can be easily included in your project.  
To add `ClIO` to your project, simply add the following dependency definition to your `Package.swift`:
```swift
private let clioDependency =
  Package.Dependency.package(
    url: "https://github.com/alex-apriamashvili/ClIO.git",
    .upToNextMajor(from: "0.0.2")
)
```
Now you can specify this package dependency among your `Package.dependencies` as:
```swift
let package = Package(
    name: "YourPackageName",
    dependencies: [
      ...,
      clioDependency,
    ],
    ...
)
```
Please, note that version `0.0.2` might not be the latest available at the moment. To get the latest available release number, visit [Releases](https://github.com/alex-apriamashvili/ClIO/releases).

---
\* – if some of the input parameters don't have options, please, refer to `MockOption` in tests to see how such cases could be described.
