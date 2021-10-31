import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func EnterButtonPress(_ sender: Any) {
        present(ActivityTabBarController(nibName: "ActivityTabBar", bundle: nil), animated: true, completion: nil)
    }
}
