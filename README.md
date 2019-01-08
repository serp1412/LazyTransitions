<h1 align="center">LazyTransitions</h1>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS8+-blue.svg?style=flat" alt="Platform: iOS 8+"/>
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift%203-4BC51D.svg?style=flat" alt="Language: Swift 3" /></a>
    <img src="https://img.shields.io/cocoapods/v/LazyTransitions.svg" alt="Cocoapods"/>
    <a href="https://img.shields.io/cocoapods/v/LazyTransitions.svg">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage Compatible"/>
    <a href="https://github.com/Carthage/Carthage">
    <a href="https://codecov.io/gh/serp1412/LazyTransitions">
    <img src="https://codecov.io/gh/serp1412/LazyTransitions/branch/master/graph/badge.svg" /></a>    
    <img src="https://travis-ci.org/serp1412/LazyTransitions.svg?branch=master"/>
    <a href="">
    <img src="http://img.shields.io/badge/license-BSD-lightgrey.svg?style=flat" alt="License: BSD" />
    <a href="http://twitter.com/serp1412"><img src="https://img.shields.io/badge/twitter-@serp1412-blue.svg?style=flat" alt="Twitter: serp1412" /></a>
</p>

A simple framework that allows you to create similar lazy pops and dismisses like in the Facebook, Instagram or Twitter apps.

<p align="center" >
<img src="https://github.com/serp1412/LazyTransitions/blob/master/LazyTransitionsDemo.gif" alt="LazyTransitions" title="LazyTransitions demo">
</p>

## Installation

### CocoaPods

Add the following line to your PodFile:

``` pod 'LazyTransitions' ``` 

### Carthage

Add the following line to your `Cartfile`

``` github "serp1412/LazyTransitions" ```

## Usage

Here's the simplest way to use `LazyTransitions`

* Import the framework in the view controller that you want to make lazy
```swift
import LazyTransitions
```
* Make the view controller lazy for the transition that you need
```swift
func viewDidLoad() {
    becomeLazy(for: .dismiss) // or .pop if have pushed this screen
}
```
* A lazy transition trigger is automatically added to the screen's `view` property. But you can add transition triggers (i.e. panning on them will also trigger a transition) for other views in your screen
```swift
addTransition(forView: view)
// or
addTransition(forScrollView: scrollView)
```

### Example

Here's some sample code on how to use LazyTransitions in your project.

```swift
import LazyTransitions

class LazyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        becomeLazy(for: .dismiss)
    }
}
```

That's it! 😜

## More Info Please!

If you want to find out about more use cases for `LazyTransitions` or just mess around with it a bit.
1. Clone this project
2. Open it in Xcode and find the `LazyTransitions.playground` file
3. Open the `README` playground page and follow the instructions inside.

I hope you enjoy using this framework as much as I did creating it 😊
