import UIKit

class AuthorizationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authorizeDidPress(_ sender: Any) {
        performSegue(withIdentifier: "ActivityTabBarControllerView", sender: nil)
    }
}
