import UIKit

class AuthorizationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Authorization(_ sender: Any) {
        performSegue(withIdentifier: "ActivityTabBarControllerView", sender: nil)
    }
}
