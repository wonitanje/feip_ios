import UIKit
import CoreLocation

class ActivityController: UIViewController {

    // MARK: - Private vars
    private var tableData: [ActivitiesTableModel] = []
    private var activitiesGroup: Int = 0 {
        didSet {
            fetch()
        }
    }

    // MARK: - Outlets
    @IBOutlet var segmentContainerView: UIView!
    @IBOutlet var segmentControlView: UISegmentedControl!
    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var emptyStateView: UIView!

    // MARK: - Mapping
    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStateView.isHidden = false
        activityTableView.isHidden = true

        activityTableView.dataSource = self
        activityTableView.delegate = self
        
        segmentContainerView.layer.borderColor = UIColor.systemGray4.cgColor
        segmentContainerView.layer.borderWidth = 1

        fetch()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        activityTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 86, right: 0)
    }

    // MARK: - Private funcs
    private func fetch() {
        if activitiesGroup == 0 {
            fetchUserActivities()
        } else {
            fetchSocialActivities()
        }
    }
    
    private func fetchLocalActivities() {
        let context = FEFUCoreDataContainer.instance.context
        let request = CDActivity.fetchRequest()

        do {
            let rawActivities = try context.fetch(request)
            let activities: [ActivityTableCellModel] = rawActivities.map { activity in
                let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()
                return ActivityTableCellModel(distance: activity.distance,
                                              duration: activity.duration,
                                              type: activity.type,
                                              icon: image,
                                              startDate: activity.startDate,
                                              stopDate: activity.stopDate,
                                              name: "")
            }
            let sortedActivities = activities.sorted { $0.startDate > $1.startDate }
            let grouppedActivities = Dictionary(grouping: sortedActivities, by: { $0.startDate.callendarDate() }).sorted(by: {
                $0.key > $1.key
            })
            tableData = grouppedActivities.map { (date, activities) in
                return ActivitiesTableModel(date: date, activities: activities)
            }
            
            reloadTable()
        } catch {
            print(error)
        }
    }

    private func fetchUserActivities() {
        UserService.activities() { activities in
            DispatchQueue.main.async {
                self.fillTable(selfActivities: activities)
                self.reloadTable()
            }
        } reject: { err in
            DispatchQueue.main.async {
                self.fetchLocalActivities()
            }
        }
    }
    
    private func fetchSocialActivities() {
        ActivityService.activities { activities in
            self.fillTable(socialActivities: activities)
            self.reloadTable()
        } reject: { err in
            DispatchQueue.main.async {
                self.segmentControlView.selectedSegmentIndex = 0
            }
        }
    }
    
    private func fillTable(selfActivities: ActivitiesResponseModel? = nil, socialActivities: SocialActivitiesResponseModel? = nil) {
        if let selfActivities = selfActivities {
            let selfActivities: [ActivityTableCellModel] = selfActivities.items.map { activity in
                let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()
                let duration = activity.endsAt.timeIntervalSinceReferenceDate - activity.startsAt.timeIntervalSinceReferenceDate
                let distance = activity.geoTrack.distance(from: 0, to: activity.geoTrack.count)

                return ActivityTableCellModel(distance: Double(distance),
                                              duration: duration,
                                              type: activity.activityType.name,
                                              icon: image,
                                              startDate: activity.startsAt,
                                              stopDate: activity.endsAt,
                                              name: "")
            }
            let sortedActivities = selfActivities.sorted { $0.startDate > $1.startDate }
            let grouppedActivities = Dictionary(grouping: sortedActivities, by: { $0.startDate.callendarDate() }).sorted(by: {
                $0.key > $1.key
            })
            
            tableData = grouppedActivities.map { (date, activities) in
                return ActivitiesTableModel(date: date, activities: activities)
            }
        }
        
        if let socialActivities = socialActivities {
            let socialActivities: [ActivityTableCellModel] = socialActivities.items.map { activity in
                let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()
                let duration = activity.endsAt.timeIntervalSinceReferenceDate - activity.startsAt.timeIntervalSinceReferenceDate
                
                var prevLocation: CLLocation? = nil
                let distance = activity.geoTrack.reduce(Double(0), { distance, point in
                    let location = CLLocation(latitude: point.lat, longitude: point.lon)
                    
                    var res = distance
                    if prevLocation != nil {
                        res += location.distance(from: prevLocation!)
                    }
                    prevLocation = location

                    return res
                })

                return ActivityTableCellModel(distance: Double(distance),
                                              duration: duration,
                                              type: activity.activityType.name,
                                              icon: image,
                                              startDate: activity.startsAt,
                                              stopDate: activity.endsAt,
                                              name: activity.user.name)
            }
            let sortedActivities = socialActivities.sorted { $0.startDate > $1.startDate }
            let grouppedActivities = Dictionary(grouping: sortedActivities, by: { $0.startDate.callendarDate() }).sorted(by: {
                $0.key > $1.key
            })
            
            tableData = grouppedActivities.map { (date, activities) in
                return ActivitiesTableModel(date: date, activities: activities)
            }
        }
    }

    private func reloadTable() {
        DispatchQueue.main.async {
            self.activityTableView.reloadData()
            self.activityTableView.isHidden = self.tableData.isEmpty
            self.emptyStateView.isHidden = !self.tableData.isEmpty
        }
    }
    
    // MARK: - Actions
    @IBAction func startActivityDidPressed(_ sender: Any) {
        let vc = ActivityRouteController().initializeViewController(presentStyle: .overFullScreen)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func segmentControlDidChange(_ sender: Any) {
        activitiesGroup = segmentControlView.selectedSegmentIndex
    }
    
    // MARK: - Public funcs
    func initializeViewController(presentStyle: UIModalPresentationStyle = .fullScreen) -> UINavigationController {
        let vc = super.initializeViewController("Activity", presentStyle) as! UINavigationController

        return vc
    }
}

// MARK: - TableView DataSource and Delegate
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
        
        guard let cell = reusableCell as? ActivityTableCellController else {
            return UITableViewCell()
        }

        cell.bind(activityData)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = self.tableData[indexPath.section].activities[indexPath.row]
        let vc = ActivityDetailsController().initializeViewController(model, presentStyle: .overFullScreen)

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ActivityController: ActivityRouteDelegate {
    func activityDidCreate() {
        fetch()
    }
}
