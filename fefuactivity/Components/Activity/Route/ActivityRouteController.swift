import UIKit
import MapKit
import CoreLocation

class ActivityRouteController: UIViewController {

    // MARK: - Public vars
    weak var delegate: ActivityRouteDelegate?
    
    // MARK: - Private vars
    private var latitude: Double = 500
    private var longitude: Double = 500
    private var deviceLocationIdentifier: String = "DeviceLocationActive"
    private var routingStarted: Bool = false

    private var activityCollectionData: [ActivityCollectionCellModel] = []
    private var activityType: ActivityCollectionCellModel?
    private var previousRoute: MKOverlay?
    private var timer: Timer = Timer()
    private var startDate: Date = Date()
    private var distance: CLLocationDistance = CLLocationDistance() {
        didSet {
            distanceLabel.text = String(format: "%.2f км", distance / 1000)
        }
    }

    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        return manager
    }()

    private var deviceLocation: CLLocation? {
        didSet {
            if let deviceLocation = deviceLocation {
                let region = MKCoordinateRegion(center: deviceLocation.coordinate, latitudinalMeters: latitude, longitudinalMeters: longitude)
                
                mapView.setRegion(region, animated: true)

                guard routingStarted else {
                    return
                }
                deviceRoute.append(deviceLocation)
                if oldValue != nil {
                    distance += deviceLocation.distance(from: oldValue!)
                }
            }
        }
    }
    private var deviceRoute: [CLLocation] = [] {
        didSet {
            let coordinates = deviceRoute.map {
                $0.coordinate
            }
            
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            route.title = "Ваш маршрут"

            if let removeRoute: MKOverlay = previousRoute {
                mapView.removeOverlay(removeRoute)
            }
            mapView.addOverlay(route)
            previousRoute = route
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
    }
    @IBOutlet weak var typesCollection: UICollectionView!
    @IBOutlet weak var startView: UIView! {
        didSet {
            proccessView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var proccessView: UIView! {
        didSet {
            proccessView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    // MARK: - Mapping
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Новая активность"
        self.tabBarController?.tabBar.isHidden = true
        proccessView.isHidden = true

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        loadTypes()

        displayStartView()
    }
    
    // MARK: - Actions
    @IBAction func startDidPress(_ sender: Any) {
        activityDidStart()
    }
    @IBAction func stopDidPress(_ sender: Any) {
        activityDidStop()
    }
    @IBAction func toggleDidPress(_ sender: Any) {
    }
    
    

    // MARK: - Private funcs
    private func loadTypes() {
        ActivityService.types() { types in
            DispatchQueue.main.async {
                self.activityCollectionData = types
//                self.typesCollection.reloadData()
                self.typesCollection.delegate = self
                self.typesCollection.dataSource = self
            }
        } reject: { err in
            print(err)
        }
    }
    private func displayStartView() {
        startView.isHidden = false
        proccessView.isHidden = true
    }
    private func displayProccessView() {
        startView.isHidden = true
        proccessView.isHidden = false
        
//        print(activityType?.name ?? "imya")
//        print(activityType)
        typeLabel.text = activityType?.name
    }

    private func activityDidStart() {
        routingStarted = true
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        timer.tolerance = 0.1

        startDate = Date()

        displayProccessView()
    }

    private func activityDidStop() {
        locationManager.stopUpdatingLocation()
        routingStarted = false

        timer.invalidate()

        saveActivity()

        activityDidCreate()

        self.navigationController?.popViewController(animated: true)
    }

    private func saveActivity() {
        let coreData = FEFUCoreDataContainer.instance
        let activity = CDActivity(context: coreData.context)
        activity.duration = durationLabel.text!
        activity.distance = distanceLabel.text!
        activity.startDate = startDate
        activity.stopDate = Date()
        activity.type = activityType?.name ?? ""
        coreData.saveContext()

        let data = ActivityRequestModel(startsAt: activity.startDate, endsAt: activity.stopDate, activityTypeId: activityType?.id ?? 0, geoTrack: deviceRoute.map {
            LocationModel(lat: $0.coordinate.latitude, lon: $0.coordinate.longitude)
        })

        UserService.saveActivity(data) { activity in
            print("\n\n\n new Activity: ", activity)
        } reject: { err in
            print("error", err as Any)
        }
    }

    // MARK: - Timer
    @objc func updateTimer() {
        let duration = Date().timeIntervalSince(startDate)

        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.zeroFormattingBehavior = .pad

        durationLabel.text = timeFormatter.string(from: duration)
    }

    // MARK: - Public funcs
    func initializeViewController(presentStyle: UIModalPresentationStyle = .overFullScreen) -> ActivityRouteController {
        let vc = super.initializeViewController("ActivityRoute", presentStyle) as! ActivityRouteController

        return vc
    }
}

// MARK: - CLLocation Delegate
extension ActivityRouteController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        
        deviceLocation = currentLocation
    }
}

// MARK: - MKMap Delegate
extension ActivityRouteController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.fillColor = UIColor.blue
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5
            
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKUserLocation {
            let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: deviceLocationIdentifier)

            let view = dequedView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: deviceLocationIdentifier)

            view.image = UIImage(named: "DeviceLocationActive")

            return view
        }

        return nil
    }
}

// MARK: - ActivityRoute Delegate
extension ActivityRouteController: ActivityRouteDelegate {
    func activityDidCreate() {
        print("\n\n\nDid create\n\n")
        delegate?.activityDidCreate()
    }
}

// MARK: - Collection DataSource
extension ActivityRouteController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count: ", activityCollectionData.count)
        return activityCollectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = activityCollectionData[indexPath.row]

        let dequeuedCell = typesCollection.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionCell", for: indexPath)

        guard let cell = dequeuedCell as? ActivityCollectionCellController else {
            return UICollectionViewCell()
        }

        cell.bind(cellData)
        if (cellData.id == activityType?.id) {
            cell.focus()
        }

        return cell
    }
}

// MARK: - Collection Delegate
extension ActivityRouteController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as?
            ActivityCollectionCellController {
            cell.focus()
        }

        activityType = activityCollectionData[indexPath.row]
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ActivityCollectionCellController {
            cell.unfocus()
        }
    }
}
