//
//  AppDelegate.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?
    
    private var launchRouter: LaunchRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let launchRouter = MasterBuilder(dependency: EmptyComponent()).build()
        
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        
        return true
    }
}
