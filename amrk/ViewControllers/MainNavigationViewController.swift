/*********************		Yousef El-Madhoun		*********************/
//
//  MainNavigationViewController.swift
//  amrk
//
//  Created by yousef on 12/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        
        let viewControllersNames = viewControllers.map { viewController in
            let item = NSStringFromClass(viewController.classForCoder).components(separatedBy: ".").last ?? ""
            return item
        }
                
        Logger.shared.debugPrint("🟢 [Navigator] Set => \(viewControllersNames.joined(separator: ", "))", plain: true)
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        Logger.shared.debugPrint("🟢 [Navigator] Push => \(NSStringFromClass(viewController.classForCoder).components(separatedBy: ".").last ?? "")", plain: true)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
      let popped = super.popViewController(animated: animated)
        
        if let pop = popped {
            Logger.shared.debugPrint("🟢 [Navigator] Pop => \(NSStringFromClass(pop.classForCoder).components(separatedBy: ".").last ?? "")", plain: true)
        }
    
      return popped
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    let popped = super.popToRootViewController(animated: animated)
      
        if let pop = popped?.last {
            Logger.shared.debugPrint("🟢 [Navigator] Pop To Root => \(NSStringFromClass(pop.classForCoder).components(separatedBy: ".").last ?? "")", plain: true)
      }
        
      return popped
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {

    let popped = super.popToViewController(viewController, animated: animated)
      
        if let pop = popped?.last {
            Logger.shared.debugPrint("🟢 [Navigator] Pop To => \(NSStringFromClass(pop.classForCoder).components(separatedBy: ".").last ?? "")", plain: true)
      }
        
      return popped
    }
    
}


extension MainNavigationViewController {
    
    func setupView() {
        AppDelegate.shared.rootNavigationViewController = self
        
//        var vcName = ""
//
//        if UserProfile.shared.language == nil {
//            vcName = "SelectLanguageViewController"
//        } else if !(UserProfile.shared.isOpenApp ?? true) {
//            vcName = "OnBoardingViewController"
//        } else if UserProfile.shared.currentUser != nil {
//            vcName = "MainTabbarViewController"
//        } else {
//            vcName = "SignInPopupViewController"
//        }
        
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        AppDelegate.shared.rootNavigationViewController.setViewControllers([vc], animated: true)
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}
