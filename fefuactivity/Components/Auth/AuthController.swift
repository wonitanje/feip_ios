import UIKit

class AuthController: UIViewController {
    // MARK: - Public funcs
    func initializeViewController(presentStyle: UIModalPresentationStyle = .fullScreen) -> UINavigationController {
        let vc = super.initializeViewController("Auth", presentStyle) as! UINavigationController

        return vc
    }

    // MARK: - Actions
    @IBAction func registrationDidPress(_ sender: Any) {
        let vc = RegistrationController().initializeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func authorizationDidPress(_ sender: Any) {
        let vc = AuthorizationController().initializeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
