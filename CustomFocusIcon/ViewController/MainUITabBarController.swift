import Foundation
import UIKit

class MainUITabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #unavailable(iOS 14.0) { // 不支持iOS 14以下系统版本，iOS 14也不支持，打算打开以后给个提示
            exit(0)
        }
        
        // 设置背景颜色
        view.backgroundColor = .systemBackground
        
        // 隐藏iPad OS 18开始的顶部TabBar
        if #available(iOS 18.0, *), UIDevice.current.userInterfaceIdiom == .pad {
            setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: .compact), forChild: self)
        }
        
        // 首页的ViewController
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        // 设置页面的ViewController
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings", comment: ""), image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        
        // 添加ViewController到TabBar
        self.viewControllers = [UINavigationController(rootViewController: homeViewController),
                                UINavigationController(rootViewController: settingsViewController)]
    }
}
