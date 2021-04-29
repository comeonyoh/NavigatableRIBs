# NavigatableRIBs


## A problem what I want to solve

When we use the UINavigationController, we usually call `popViewController` by actionable event or use just swipe gesture from left to right.
It automatically deallocate `topViewController` of UINavigationController and don't care about it.

When I tried to it with [RIBs framework](https://github.com/uber/RIBs), there are some problems.
I can't call `detachChild` method of the router so it makes a memory leak bug. 


## The goal
* Handle all the cases of navigation
* Not alter the pre-written codes. Let's just add some protocol for navigation.
* Forced navigation rules.

## Implementations
1. For handle all cases of navigation.
Let's use `UINavigationControllerDelegate` and understand how to `didShow` method works. Behind the scene, I think after `animateTransition` method call and the `transitionContext: UIViewControllerContextTransitioning` transitionContext `didCompleted` with `true` value, `didShow` method of `UINavigationControllerDelegate` will be called. So we can trustly use the `didShow` method.

2. Not alter the pre-written codes. Let's just add some protocol for navigation.
We have huge pre-written codes with RIBs framework. So just using `ViewControllable` protocol in RIBs. I make a `NavigationControllable` protocol which conform to `ViewControllable` and it makes rule for navigation. The `routing` in this protocol is core variable. after the navigation `didShow`, it looks up the `routing` and deactive children. `NavigationDetector` protocol will be recevied the `didShow` event finished and detaches children router recursively.

  **Why Recursive?**  
    in iOS 14 and above, there is a new feature which show a menu button when the user long-click the button. So I have to detach multiple routers recursively.


3. NotForced navigation rules.
Even though the seasonal QA engineers, It is very difficult to find memory/multi-threading bugs when they tried to it. So we have to use `assert` to notify to the developers who use this rules and NavigationController. So I defined the rules in UINavigationController.


```swift
if let topViewController = self.topViewController, topViewController.isKind(of: UINavigationController.classForCoder()) == false {
    assert(topViewController is NavigationDetector, "Current topViewController must be NavigationDetector.")
}

assert(viewController is NavigationControllable, "Only 'NavigationControllable' UIViewController can be pushed on the stack.")

```

## Technologies
* [RIBs](https://github.com/uber/RIBs)
* [Engineering the Architecture Behind Uber’s New Rider App](https://eng.uber.com/new-rider-app/)
* [UINavigationControllerDelegate](https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate)
* [UIViewControllerAnimatedTransitioning](https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning)
* [View Controller Programming Guide for iOS](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/index.html)
