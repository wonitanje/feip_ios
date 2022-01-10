import UIKit

class ActivityTabBarController: UITabBarController {
    override func viewDidLoad() {
            super.viewDidLoad()

            initTabBar()
        }

    func initTabBar() {
        let activityNC = UINavigationController(rootViewController: ActivityController())
        let profileNC = UINavigationController(rootViewController: ProfileController())

        activityNC.tabBarItem.title = "Активности"
        activityNC.tabBarItem.image = UIImage(systemName: "circle")

        profileNC.tabBarItem.title = "Профиль"
        profileNC.tabBarItem.image = UIImage(systemName: "circle")

        self.setViewControllers([activityNC, profileNC], animated: true)

        modalPresentationStyle = .overFullScreen
    }

    static func presentControllerView(_ sender: UIViewController) {
        let controller = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "Init")
        controller.modalPresentationStyle = .fullScreen
        sender.present(controller, animated: true, completion: nil)
    }
}
