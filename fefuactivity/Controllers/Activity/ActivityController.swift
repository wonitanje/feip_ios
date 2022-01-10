import UIKit

struct ActivitiesTableModel {
    let date: Date
    let activities: [ActivityCellModel]
}

class ActivityController: UIViewController {
    
    private var selectedSection: Int!
    private var selectedRow: Int!

    private var tableData: [ActivitiesTableModel] = []

    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var emptyStateView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStateView.isHidden = false
        activityTableView.isHidden = true

        activityTableView.dataSource = self
        activityTableView.delegate = self

        fetch()
    }

    private func fetch() {
        let context = FEFUCoreDataContainer.instance.context
        let request = CDActivity.fetchRequest()
        
        do {
            let rawActivities = try context.fetch(request)
            let activities: [ActivityCellModel] = rawActivities.map { activity in
                let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()
                return ActivityCellModel(distance: activity.distance,
                                         duration: activity.duration,
                                         type: activity.type,
                                         icon: image,
                                         startDate: activity.startDate,
                                         stopDate: activity.stopDate)
            }
            let grouppedActivities = Dictionary(grouping: activities, by: { $0.startDate.callendarDate() })
            tableData = grouppedActivities.map { (date, activities) in
                return ActivitiesTableModel(date: date, activities: activities)
            }

            activityTableView.reloadData()
            activityTableView.isHidden = tableData.isEmpty
            emptyStateView.isHidden = !tableData.isEmpty
        } catch {
            print(error)
        }
    }

    @IBAction func startActivityDidPressed(_ sender: Any) {
        performSegue(withIdentifier: "ActivityRouteView", sender: self)
    }
}

extension ActivityController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITextView()
        header.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 0)
        header.font = .boldSystemFont(ofSize: 20)
        header.text = tableData[section].date.callendarDisplay()
        header.backgroundColor = .clear
        return header
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
        case "ActivityRouteView":
            let destination = segue.destination as! ActivityRouteController
            destination.delegate = self
        default:
            break
        }
    }
}

extension ActivityController: ActivityRouteDelegate {
    func activityDidCreate() {
        fetch()
    }
}
