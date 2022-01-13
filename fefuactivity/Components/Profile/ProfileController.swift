import UIKit

class ProfileController: UITableViewController {

    // MARK: - Private vars
    private var user: UserModel? {
        didSet {
            nameLabel?.text = user?.name
            loginLabel?.text = user?.login
            genderLabel?.text = user?.gender.name
        }
    }

    // MARK: - Outlets
    @IBOutlet var profileTable: UITableView! {
        didSet {
            profileTable.delegate = self
        }
    }
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!

    // MARK: - Mapping
    override func viewWillAppear(_ animated: Bool) {
        UserService.profile { user in
            DispatchQueue.main.async {
                self.user = user
            }
        } reject: { err in
            print(err)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Профиль"
    }

    // MARK: - Actions
    @IBAction func logoutDidPress(_ sender: Any) {
        AuthService.logout() {
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: "token")
                let vc = AuthController().initializeViewController()
                self.present(vc, animated: true, completion: nil)
            }
        } reject: { err in
            DispatchQueue.main.async {
                let alertMessage = APIService.errorMessage(error: err)
                let alert = UIAlertController.createErrorAlert(alertMessage, "Закрыть")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Public funcs
    func initializeViewController(presentStyle: UIModalPresentationStyle = .fullScreen) -> UINavigationController {
        let vc = super.initializeViewController("Profile", presentStyle) as! UINavigationController

        return vc
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if (cell.restorationIdentifier == "ChangePassword") {
                let vc = ChangePasswordController().initializeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
