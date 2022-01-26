import UIKit

class ActivityTableCellController: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    // MARK: - Mapping
    override func awakeFromNib() {
        super.awakeFromNib()

        cellView.layer.cornerRadius = 10
    }

    // MARK: - Public funcs
    func bind(_ model: ActivityTableCellModel) {
        distanceLabel.text = model.distance
        nameLabel.text = model.name.count != 0 ? "@\(model.name)" : ""
        durationLabel.text = model.duration
        typeIcon.image = model.icon
        typeLabel.text = model.type
        timeAgoLabel.text = model.timeAgo()
    }
}
