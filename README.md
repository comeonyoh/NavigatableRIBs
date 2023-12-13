# NavigatableRIBs

## A problem what I want to solve

- When using `UINavigationController`, we typically invoke `popViewController` through an action event or simply by swiping back from left to right. This process automatically deallocates the `topViewController` of the `UINavigationController`, eliminating the need for manual memory management.
- When I attempted this with the [RIBs framework](https://github.com/uber/RIBs/blob/main/README.md), I encountered some issues. The `detachChild` method of the router cannot be called directly because the framework does not capture the pop swipe gesture. This limitation leads to a memory leak bug.
- Unfortunately, [the RIBs framework's examples](https://github.com/uber/RIBs/tree/main/ios/tutorials) do not include any navigation examples or solutions. As a result, some developers typically resort to using the `viewDidAppear` method of `UIViewController` for supporting pop swipe gesture.
- However, I believe that such implementations indicate a lack of proper understanding of the method's intended purpose. **This approach can increase complexity and lead to unexpected errors.**


## The goal
- Let’s solve the problem with UIViewController’s life cycle.
- Let’s handle all navigation cases.
  - Simply call the `popViewController` method.
  - Support swipe-back gesture.
  - Support multiple view controllers deallocation case when either the `UITabbar` button is clicked or the navigation back button’s long click occured.
- Minimize the implementation requirements to the end users.

## Implementations

1. First, We have to know the basic parts of a RIBs.


      ![Pars of a RIBs](https://file.notion.so/f/f/f62c61a2-1d78-48f4-89d7-a763a6a75fcc/6c53111b-73ee-4f48-b31f-14df55361568/Screenshot_2023-12-13_at_3.47.24_PM.png?id=22cd3fec-9340-4cc4-9a32-93044d9d53bd&table=block&spaceId=f62c61a2-1d78-48f4-89d7-a763a6a75fcc&expirationTimestamp=1702548000000&signature=Cr5sDpBabDwYenVQrJgn-23bu9aoLXQAtlSL7LbpTEM&downloadName=Screenshot+2023-12-13+at+3.47.24%E2%80%AFPM.png)
    - Router: A Router listens to the Interactor and translates its outputs into attaching and detaching child RIBs.
    - View(View Controller): Views build and update the UI. Views are designed to be as “dumb” as possible. They just display information.

2. Second, We have to know the life cycle of `UINavigationController`.


      ![UINavigationController's stack](https://file.notion.so/f/f/f62c61a2-1d78-48f4-89d7-a763a6a75fcc/5852c8b9-94d9-44b9-8953-ec4fd6662297/Screenshot_2023-12-13_at_4.22.08_PM.png?id=eb83de49-83f8-42ff-8170-3a14058ed4b1&table=block&spaceId=f62c61a2-1d78-48f4-89d7-a763a6a75fcc&expirationTimestamp=1702548000000&signature=h2hppUFymEeuQcZVNsxJWzDgN82Z0locyXZeqkQpO2Q&downloadName=Screenshot+2023-12-13+at+4.22.08%E2%80%AFPM.png)

    - When UINavigationController pops the UIViewController-C, the delegate method  `navigationController(_:didShow:animated:)` is called, with the `didShow` parameter specifically indicating the UIViewController that was shown.
    
3. As a result,

      ![AS_A_RESULT](https://file.notion.so/f/f/f62c61a2-1d78-48f4-89d7-a763a6a75fcc/c152e9ac-0a14-4814-b0eb-2fe2a5dd6f68/Screenshot_2023-12-13_at_4.29.24_PM.png?id=ee930ce7-ea35-45c8-a6b8-f20f0d29f3e5&table=block&spaceId=f62c61a2-1d78-48f4-89d7-a763a6a75fcc&expirationTimestamp=1702548000000&signature=mRy4DDgou84fvul4E4PnZWWpdITJJAWMS_lfSq9S-O8&downloadName=Screenshot+2023-12-13+at+4.29.24%E2%80%AFPM.png)

    - When the `navigationController(_:didShow:animated:)` is called, it is necessary to locate the RIB family(especially the Router) associated with the `didShow` UIViewController. Subsequently, we should invoke the `detach` method to remove child elements from the memory.

4. As a code
    - Create a common `UINavigationController` and set it to delegate to itself. We define a `cachedViewController` property to call `detach` method.
    - When the `navigationController(_:didShow:animated:)` is called, we handle it based on whether it confirms to the RIBs framework.

        ```swift
        public class CommonRIBNavigationController: UINavigationController, UINavigationControllerDelegate {

        private var cachedViewController: [UIViewController] = []

        public override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
        }
        
        public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            
            super.pushViewController(viewController, animated: animated)
            
            if cachedViewController.contains(viewController) == false {
                cachedViewController.append(viewController)
            }
        }
    
        public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
            
            guard cachedViewController.count > children.count else { return }
            
            guard let currentIndex = cachedViewController.firstIndex(of: viewController), cachedViewController.count > currentIndex + 1 else { return }
            
            //  When the last dismissed view controller is kind of a RIBs and CommonRIBsViewController.
            guard cachedViewController[currentIndex + 1] is ViewControllable, let current = cachedViewController[currentIndex] as? CommonRIBsViewController else {
                cachedViewController = Array(cachedViewController[0...currentIndex])
                return
            }
            
            current.resourceFlusher?.flushRIBsResources()
            cachedViewController = Array(cachedViewController[0...currentIndex])
        }
        ```
    - Create a common `UIViewController` and `Router`(RIBs).
        - CommonRIBsViewController: In this scenario, it must identify the appropriate router to release the resources of the child RIBs.
        - CommonRIBsRouter: Using common router is mandatory to find and release RIBs resources.
            ```swift
            public protocol CommonRIBsInteractable: Interactable {
                var resourceFlusher: CommonRIBsResourceFlush? { get }
            }
            
            public protocol CommonRIBsResourceFlush {
                func flushRIBsResources()
            }
            
            public class CommonRIBsViewController: UIViewController, ViewControllable {
                
                public var resourceFlusher: CommonRIBsResourceFlush? {
                    nil
                }
            }
            
            public class CommonRIBsRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>, CommonRIBsResourceFlush {
                
                public var nextScreenRouter: ViewableRouting?
                
                /**
                  Easy short-cut push method to use same router.
                */
                @discardableResult
                public func push(nextRouter: ViewableRouting?, animated: Bool) -> Bool {
                    
                    if nextScreenRouter != nil {
                        flushRIBsResources()
                    }
                    
                    guard let next = nextRouter else { return false }
                    
                    nextScreenRouter = next
                    nextScreenRouter?.interactable.activate()
                    nextScreenRouter?.load()
                    
                    viewControllable.uiviewController.navigationController?.pushViewController(next.viewControllable.uiviewController, animated: animated)
                    return true
                }
            
                /**
                  Deactivate RIBs resource and set nil
                */
                public func flushRIBsResources() {
                    
                    nextScreenRouter?.interactable.deactivate()
                    nextScreenRouter = nil
                }
            }
            ```
    - Example
        ```swift
        final class MasterViewController: CommonRIBsViewController, MasterPresentable {
        
            override var resourceFlusher: CommonRIBsResourceFlush? {
        
                guard let listener = listener as? CommonRIBsInteractable else { return nil }
                return listener.resourceFlusher
            }
        		
            // ... Do other things...   
        }
        
        protocol MasterInteractable: CommonRIBsInteractable {
            // ... Do other things...
        }
        
        final class MasterInteractor: PresentableInteractor<MasterPresentable>, MasterInteractable {
            
            public var resourceFlusher: CommonRIBsResourceFlush? {
                router as? CommonRIBsResourceFlush
            }
        
            // ... Do other things...
        }
        
        final class MasterRouter: CommonRIBsRouter <MasterInteractable, ViewControllable>, MasterRouting, LaunchRouting {
            
            // ... Do other things...
            func routeToDetail(at case: MasterExampleCase) {
                
                let detail = DetailBuilder(dependency: EmptyComponent()).build(`case`)
                // Use common push method.`
                push(nextRouter: detail, animated: true)
            }
        }
        ```
## Technologies
* [Notion Blog](https://www.notion.so/comeonyoh89/NavigatableRIBs-f18261ab3efb458aa12b077b4f48a18e?pvs=4)
* [RIBs](https://github.com/uber/RIBs)
* [Engineering the Architecture Behind Uber’s New Rider App](https://eng.uber.com/new-rider-app/)
* [UINavigationControllerDelegate](https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate)
* [UIViewControllerAnimatedTransitioning](https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning)
* [View Controller Programming Guide for iOS](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/index.html)
