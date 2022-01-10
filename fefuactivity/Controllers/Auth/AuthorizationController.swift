import UIKit

class AuthorizationController: UIViewController {

    @IBOutlet weak var loginField: CustomTextField!
    @IBOutlet weak var passwordField: SecureTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authorizeDidPress(_ sender: Any) {
        let login = loginField.text ?? ""
        let password = passwordField.text ?? ""

        let loginData = LoginRequestModel(login: login, password: password)

        do {
            let data = try AuthService.encoder.encode(loginData)
            AuthService.login(data) { auth in
                DispatchQueue.main.async {
                    UserDefaults.standard.set(auth.token, forKey: "token")
                    ActivityTabBarController.presentControllerView(self)
//                    let vc = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "Init")
//                    vc.modalPresentationStyle = .fullScreen
//                    self.present(vc, animated: true, completion: nil)
                }
            } reject: { err in
                DispatchQueue.main.async {
                    let alertMessage = AuthService.errorMessage(error: err)
                    let alert = UIAlertController.createErrorAlert(alertMessage, "Закрыть")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } catch {
            print(error)
        }
    }
}
