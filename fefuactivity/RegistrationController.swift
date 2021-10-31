import UIKit

class RegistrationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Registration(_ sender: Any) {
        performSegue(withIdentifier: "ActivityTabBarControllerView", sender: nil)
    }
}
