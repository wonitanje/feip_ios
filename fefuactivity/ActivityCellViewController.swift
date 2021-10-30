import UIKit

struct ActivityCellViewModel {
    let distance: String
    let duration: String
    let type: String
    let timeAgo: String
    let icon: UIImage
    let startTime: String
    let stopTime: String
}

class ActivityCellViewController: UITableViewCell {


    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    func bind(_ model: ActivityCellViewModel) {
        distanceLabel.text = String(model.distance)
        durationLabel.text = String(model.duration)
        typeLabel.text = model.type
        timeAgoLabel.text = model.timeAgo
        typeIcon.image = model.icon
    }
}
