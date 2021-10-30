import UIKit

struct ActivitiesTableViewModel {
    let date: String
    let activities: [ActivityCellViewModel]
}

class ActivityController: UIViewController {

    private let tableData: [ActivitiesTableViewModel] = {
        let yesterdayActivities: [ActivityCellViewModel] = [
            ActivityCellViewModel(
                distance: "14.32 км",
                duration: "2 часа 46 минут",
                type: "Велосипед",
                timeAgo: "14 часов назад",
                icon: UIImage(systemName: "bicycle.circle.fill") ?? UIImage(),
                startTime: "14:49",
                stopTime: "16:31"
            )
        ]
        let mayActivities: [ActivityCellViewModel] = [
            ActivityCellViewModel(
                distance: "14.32 км",
                duration: "2 часа 46 минут",
                type: "Велосипед",
                timeAgo: "14 часов назад",
                icon: UIImage(systemName: "bicycle.circle.fill") ?? UIImage(),
                startTime: "14:49",
                stopTime: "16:31"
            )
        ]
        
        return [
            ActivitiesTableViewModel(date: "Вчера", activities: yesterdayActivities),
            ActivitiesTableViewModel(date: "Май 2020 года", activities: mayActivities)
        ]
    }()

    @IBOutlet weak var activitiesTableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitiesTableView.dataSource = self
        //emptyStateView.isHidden = false
    }

    @IBAction func startButton(_ sender: Any) {
        emptyStateView?.isHidden = true
    }
}

extension ActivityController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.font = .boldSystemFont(ofSize: 20)
        header.text = tableData[section].date
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let activityData = self.tableData[indexPath.section].activities[indexPath.row]
        
        let reusableCell = activitiesTableView.dequeueReusableCell(withIdentifier: "ActivityCellViewController", for: indexPath)
        
        guard let cell = reusableCell as? ActivityCellViewController else {
            return UITableViewCell()
        }

        cell.bind(activityData)
        return cell
    }
    
}
