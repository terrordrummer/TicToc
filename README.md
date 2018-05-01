# TicToc

[![CI Status](http://img.shields.io/travis/terrordrummer/TicToc.svg?style=flat)](https://travis-ci.org/terrordrummer/TicToc)
[![Version](https://img.shields.io/cocoapods/v/TicToc.svg?style=flat)](http://cocoapods.org/pods/TicToc)
[![License](https://img.shields.io/cocoapods/l/TicToc.svg?style=flat)](http://cocoapods.org/pods/TicToc)
[![Platform](https://img.shields.io/cocoapods/p/TicToc.svg?style=flat)](http://cocoapods.org/pods/TicToc)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

TicToc is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TicToc'
```
## Overview
TicToc is a simple module intended to measure elapsed time across two events: the `tic()` and the `toc()`. The `tic()` event triggers the starting timestamp while the `toc()` returns the elapsed time since the last tic event.

Once the `tic()` event is called, multiple `toc()` events could be called to get the incremental elapsed times.

There are two available tic/toc events, a static pair and an instance-binded pair.
The static one are useful whenever the tic/toc events need to be triggered from different classes while the instance-binded one are intended to be used for local measurement.

Few more static helper methods are provieded to write the elapsed time measuring code in a more readable fashion.

## Examples
### Static Tic/Toc
Call the static `TicToc.tic()` method to start the measurement and the `TicToc.toc()` to retrieve the elapsed time. 

### Instance-binded Tic/Toc
Anywhere needed you can instantiate a TicToc class

```swift
let tictoc = TicToc()
```

By default, when `TicToc()` is instantiated the `tic()` method is called. Next, call the `toc()` methods to get the elapsed time

```swift
// ... some operations
let elapsedTime = tictoc.toc()
```

### Measure Helper
Two static methods `TicToc.measure` are provieded as an optional way to make the measurement operations more readable.

One version measures an operation synchronously while the second one provies a completion block to be called when the operation is finished (so the operation block could consist in some asyncronously dispatched operations).

The synchronous version accepts a label to be used as a prefix in the log string:

```swift
TicToc.measure(label: "Operation completed in") {
	// ...some operations
}
// this will log "Operation completed in 3.23 sec"
```

The second version both accepts the label and executes the operation block synchronously but the closure receives a completion callback to be called whenever the operation is finished:

```swift
TicToc.measure(label: "Operation completed in") { (completion) in

	// ...do whatever needed, dispatch, fetch, etc...
	
	// wherever the measured operation is completed
	completion()
}
```

### Log Control
Tipically, you probably don't want time-measurement logs to be generated in production. To address this requirement a static flag `logEnabled` is provided to enable/disable the output of the latter `measure` methods:

```swift
TicToc.logEnabled = false // <- inhibits the log output
TicToc.measure(label: "Operation completed in") {
	// ...
}
// no logs will be printed
```
## Author

terrordrummer, roberto.sartori@gmail.com,
[http://robertosartoridev.com]()

## License

TicToc is available under the MIT license. See the LICENSE file for more info.
