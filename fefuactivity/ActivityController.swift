import UIKit

struct ActivitiesTableModel {
    let date: String
    let activities: [ActivityCellModel]
}

class ActivityController: UIViewController {
    
    private var selectedSection: Int!
    private var selectedRow: Int!

    private let tableData: [ActivitiesTableModel] = {
        let yesterdayActivities: [ActivityCellModel] = [
            ActivityCellModel(
                distance: "14.32 км",
                duration: "2 часа 46 минут",
                type: "Велосипед",
                timeAgo: "14 часов назад",
                icon: UIImage(systemName: "bicycle.circle.fill"),
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
                icon: UIImage(systemName: "bicycle.circle.fill"),
                startTime: "14:49",
                stopTime: "16:31"
            )
        ]
        
        return [
            ActivitiesTableModel(date: "Вчера", activities: yesterdayActivities),
            ActivitiesTableModel(date: "Май 2020 года", activities: mayActivities)
        ]
    }()

    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var emptyStateView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enterEmptyState()

        activityTableView.dataSource = self
        activityTableView.delegate = self
        activityTableView.register(UINib(nibName: "ActivityCellView", bundle: nil), forCellReuseIdentifier: "ActivityTableCell")
    }
    
    func enterEmptyState() {
        emptyStateView.isHidden = false
        activityTableView.isHidden = true
    }
    
    func exitEmptyState() {
        emptyStateView.isHidden = true
        activityTableView.isHidden = false
    }

    @IBAction func startButton(_ sender: Any) {
        exitEmptyState()
    }
}

extension ActivityController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = tableData[section].date
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let activityData = self.tableData[indexPath.section].activities[indexPath.row]
        
        let reusableCell = activityTableView.dequeueReusableCell(withIdentifier: "ActivityTableCell", for: indexPath)
        
        guard let cell = reusableCell as? ActivityCellController else {
            return UITableViewCell()
        }

        cell.bind(activityData)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        self.selectedSection = indexPath.section
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: "ActivityDetailsView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ActivityDetailsView":
            let destination = segue.destination as! ActivityDetailsController
            destination.model = self.tableData[self.selectedSection].activities[self.selectedRow]
        default:
            break
        }
    }
}
