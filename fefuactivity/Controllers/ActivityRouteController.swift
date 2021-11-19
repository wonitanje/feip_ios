import UIKit
import MapKit
import CoreLocation

protocol ActivityRouteDelegate: AnyObject {
    func activityDidCreate()
}

class ActivityRouteController: ViewController {
    
    weak var delegate: ActivityRouteDelegate?
    
    private var latitude: Double = 500
    private var longitude: Double = 500
    private var deviceLocationIdentifier: String = "DeviceLocationActive"
    private var routingStarted: Bool = false

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

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
    }
    @IBOutlet weak var infoBarView: UIStackView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Новая активность"
        self.tabBarController?.tabBar.isHidden = true
        infoBarView.isHidden = true

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        activityDidStart()
    }

    override func viewDidDisappear(_ animated: Bool) {
        activityDidFinish()
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

        infoBarView.isHidden = false
    }

    private func activityDidFinish() {
        locationManager.stopUpdatingLocation()
        routingStarted = false

        timer.invalidate()

        let coreData = FEFUCoreDataContainer.instance
        let activity = CDActivity(context: coreData.context)
        activity.duration = durationLabel.text!
        activity.distance = distanceLabel.text!
        activity.startDate = startDate
        activity.stopDate = Date()
        activity.route = deviceRoute
        activity.type = "Велосипед"
        coreData.saveContext()

        delegate?.activityDidCreate()
    }

    @objc func updateTimer() {
        let duration = Date().timeIntervalSince(startDate)

        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.zeroFormattingBehavior = .pad

        durationLabel.text = timeFormatter.string(from: duration)
    }
}

extension ActivityRouteController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        
        deviceLocation = currentLocation
    }
}

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

extension ActivityRouteController: ActivityRouteDelegate {
    func activityDidCreate() {
        print("\n\n\n\n\n\n\n\n\n\n\nRoute Delegate")
        delegate?.activityDidCreate()
    }
}
