import UIKit

class MainController: UITabBarController {

    // MARK: - Mapping
    override func viewDidLoad() {
        super.viewDidLoad()

        initTabBar()
    }

    // MARK: - Public funcs
    func initTabBar() {
        let activityVC = ActivityController().initializeViewController()
        let profileVC = ProfileController().initializeViewController()

        activityVC.tabBarItem.title = "Активности"
        activityVC.tabBarItem.image = UIImage(systemName: "circle")

        profileVC.tabBarItem.title = "Профиль"
        profileVC.tabBarItem.image = UIImage(systemName: "circle")
        
        self.tabBar.isTranslucent = false

        self.setViewControllers([activityVC, profileVC], animated: true)
        self.modalPresentationStyle = .overFullScreen
    }

    func initializeViewController(presentStyle: UIModalPresentationStyle = .fullScreen) -> MainController {
        let vc = super.initializeViewController("Main", presentStyle) as! MainController

        return vc
    }
}
