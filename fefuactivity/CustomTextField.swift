import UIKit

class CustomTextField: UITextField {

    let toggleButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initTextField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initTextField()
    }
    
    private func initTextField() {
        if self.isSecureTextEntry {
            initSecureTextField()
        }
        
        //self.traitCollection.
        //print(self.contentType)
        
        //switch self.contentMode {
        //case "Password":
            //initPickerField()
        //case "Date Time":
            //initSecureTextField()
        //default:
            //break
        //}
    }
    
    private func initPickerField() {
        
    }
    
    private func initSecureTextField() {
        toggleButton.setImage(UIImage(named: "OpenedEye"), for: .normal)
        toggleButton.setImage(UIImage(named: "ClosedEye"), for: .selected)
        toggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        toggleButton.addTarget(self, action: #selector(toggleHandler), for: .touchUpInside)

        rightView = toggleButton
        rightViewMode = .always
    }
    
    @objc func toggleHandler(_ sender: Any) {
        self.isSecureTextEntry.toggle()

        toggleButton.isSelected.toggle()
    }
}
