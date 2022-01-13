import UIKit

class RegistrationController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var loginField: CustomTextField!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var passwordField: SecureTextField!
    @IBOutlet weak var passwordConfirmField: SecureTextField!
    @IBOutlet weak var genderField: GenderPickerTextField!

    // MARK: - Mapping
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    @IBAction func registerDidPress(_ sender: Any) {
        let login = loginField.text ?? ""
        let name = nameField.text ?? ""
        let password = passwordField.text ?? ""
        let passwordConfirm = passwordConfirmField.text ?? ""
        let gender = genderField.code

        if password != passwordConfirm {
            let alert = UIAlertController.createErrorAlert("Пароли не совпадают", "Закрыть")
            self.present(alert, animated: true, completion: nil)
            return
        }
        let data = RegisterRequestModel(login: login, password: password, name: name, gender: gender)

        do {
            let reqBody = try AuthService.encoder.encode(data)
            AuthService.register(reqBody) { user in
                DispatchQueue.main.async {
                    print(user.token)
                    UserDefaults.standard.set(user.token, forKey: "token")
                    print(UserDefaults.standard.string(forKey: "token")!)

                    let vc = MainController().initializeViewController()
                    self.present(vc, animated: true, completion: nil)
                }
            } reject: { err in
                DispatchQueue.main.async {
                    let alertMessage = "Проверьте поля:\n" + AuthService.errorMessage(error: err)
                    let alert = UIAlertController.createErrorAlert(alertMessage, "Закрыть")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } catch {
            print(error)
        }
    }

    // MARK: - Public funcs
    func initializeViewController(presentStyle: UIModalPresentationStyle = .fullScreen) -> RegistrationController {
        let vc = super.initializeViewController("Registration", presentStyle) as! RegistrationController

        return vc
    }
}
