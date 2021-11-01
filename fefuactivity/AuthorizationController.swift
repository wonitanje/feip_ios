import UIKit

class AuthorizationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authorize(_ sender: Any) {
        performSegue(withIdentifier: "ActivityTabBarControllerView", sender: nil)
    }
}
