import UIKit

class ActivityDetailsController: UIViewController {
    
    // MARK: - Public vars
    var model: ActivityTableCellModel!

    // MARK: - Outlets
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeAgoLabel1: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startStopTime: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeAgoLabel2: UILabel!

    // MARK: - Mapping
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = model.type
        
        distanceLabel.text = model.distance
        durationLabel.text = model.duration
        timeAgoLabel1.text = model.timeAgo()
        timeAgoLabel2.text = model.timeAgo()
        startStopTime.text =  "Старт: \(model.startTime()) • Финиш: \(model.stopTime())"
        typeLabel.text = model.type
        typeIcon.image = model.icon
    }

    // MARK: - Public funcs
    func initializeViewController(_ model: ActivityTableCellModel, presentStyle: UIModalPresentationStyle = .fullScreen) -> ActivityDetailsController {
        let vc = super.initializeViewController("ActivityDetails", presentStyle) as! ActivityDetailsController

        vc.model = model

        return vc
    }
}
