<img src="https://github.com/Joe0708/LogConsole/raw/master/Screenshot/SimulatorScreenShot.png" width="280" align=center>

# LogConsole

[![Version](https://img.shields.io/cocoapods/v/LogConsole.svg?style=flat)](http://cocoapods.org/pods/LogConsole)
[![License](https://img.shields.io/cocoapods/l/LogConsole.svg?style=flat)](http://cocoapods.org/pods/LogConsole)
[![Platform](https://img.shields.io/cocoapods/p/LogConsole.svg?style=flat)](http://cocoapods.org/pods/LogConsole)

A handy log console tool that can output information to the console, file, and display a small console tool in App.When the tester has problems, you can view the logs directly on the iPhone without having to connect to the IDE.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<img src="https://github.com/Joe0708/LogConsole/raw/master/Screenshot/Example.gif" width="280" align=center>

## Requirements

- iOS 8.0
- Swift Version 3.0

## Installation

LogConsole is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LogConsole"
```

## Usage

```
import LogConsole
```

Add console view to Window（Optional）
```
    let consv = ConsoleView()
    self.window?.addSubview(consv)
```

Print

```
    Logger.info("Info")
    Logger.debug("Debug")
    Logger.warning("Warning")
    Logger.error("Error")

```

Write to file

```
    Logger.saveLog()
```

You can specify the path and file name

```
    Logger.saveLog(in: CustomPath, filename: CustomFilename)
```

## TODO

1. Support horizontal screen
2. Support Custom

## Author

Joe, joesir7@foxmail.com

## License

LogConsole is available under the MIT license. See the LICENSE file for more info.
