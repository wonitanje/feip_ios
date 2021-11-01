import UIKit

class RegistrationController: UIViewController {
    
    private let genders: [String] = ["Мужской", "Женский"]
    let genderPickerView = UIPickerView()

    @IBOutlet weak var genderTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        genderPickerView.dataSource = self
        genderPickerView.delegate = self

        genderTextField.inputView = genderPickerView
    }

    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "ActivityTabBarControllerView", sender: nil)
    }
}

extension RegistrationController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        genderTextField.resignFirstResponder()
    }
}
