import UIKit

class ChangePasswordController: UITableViewController {

    @IBAction func saveDidPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initializeViewController(presentStyle: UIModalPresentationStyle = .fullScreen) -> ChangePasswordController {
        let vc = super.initializeViewController("ChangePassword", presentStyle) as! ChangePasswordController

        return vc
    }
}
