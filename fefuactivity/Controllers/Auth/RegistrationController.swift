import UIKit

class RegistrationController: UIViewController {

    @IBOutlet weak var genderTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerDidPress(_ sender: Any) {
        let vc = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "Init")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
