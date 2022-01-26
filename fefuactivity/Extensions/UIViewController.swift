import Foundation
import UIKit

extension UIViewController {
    func initializeViewController(_ storyboardName: String, _ presentStyle: UIModalPresentationStyle = .fullScreen) -> UIViewController {

        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()!

        vc.modalPresentationStyle = presentStyle

        return vc
    }
}
