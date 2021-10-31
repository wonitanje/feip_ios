import UIKit

struct ActivityTableModel {
    let date: String
    let activities: [ActivityCellModel]
}

class ActivityController: UIViewController {

    private let tableData: [ActivityTableModel] = {
        let yesterdayActivities: [ActivityCellModel] = [
            ActivityCellModel(
                distance: "14.32 км",
                duration: "2 часа 46 минут",
                type: "Велосипед",
                timeAgo: "14 часов назад",
                icon: UIImage(systemName: "bicycle.circle.fill") ?? UIImage(),
                startTime: "14:49",
                stopTime: "16:31"
            )
        ]
        let mayActivities: [ActivityCellModel] = [
            ActivityCellModel(
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
            ActivityTableModel(date: "Вчера", activities: yesterdayActivities),
            ActivityTableModel(date: "Май 2020 года", activities: mayActivities)
        ]
    }()


    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var emptyState: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Активности"

        activityTable.register(UINib(nibName: "ActivityCellView", bundle: nil), forCellReuseIdentifier: "ActivityCell")

        enterEmptyState()
    }

    @IBAction func startButtonPress(_ sender: Any) {
        exitEmptyState()
    }

    func exitEmptyState() {
        activityTable.isHidden = false
        emptyState.isHidden = true
    }
    func enterEmptyState() {
        activityTable.isHidden = true
        emptyState.isHidden = false
    }
}

extension ActivityController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.font = .boldSystemFont(ofSize: 17)
        header.text = tableData[section].date

        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let activityData = self.tableData[indexPath.section].activities[indexPath.row]
        
        let reusableCell = activityTable.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)

        guard let cell = reusableCell as? ActivityCellController else {
            return UITableViewCell()
        }

        cell.bind(activityData)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailsView = ActivityDetailsController(nibName: "ActivityDetailsView", bundle: nil)
        detailsView.model = self.tableData[indexPath.section].activities[indexPath.row]
        
        navigationController?.pushViewController(detailsView, animated: true)
    }
}
