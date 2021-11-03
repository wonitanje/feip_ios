import UIKit

class RegistrationController: UIViewController {

    @IBOutlet weak var genderTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "ActivityTabBarControllerView", sender: nil)
    }
}
