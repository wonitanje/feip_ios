import UIKit
import CoreLocation
import MapKit

class CustomAnnotation : NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class ActivityRouteController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()

        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        return manager
    }()
    
    private let deviceLocationIdentifier = "locationAnnotation"

    private var started: Bool = false
    private var previousRoute: MKOverlay? = nil

    fileprivate var deviceLocationHistory: [CLLocation] = [] {
        didSet {
            updateRoute(oldValue)
        }
    }

    var deviceLocation: CLLocation! {
        didSet {
            guard let deviceLocation = deviceLocation else {
                return
            }

            let region = MKCoordinateRegion(center: deviceLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)

            guard started else {
                started = true
                return
            }

            deviceLocationHistory.append(deviceLocation)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    func startRecord() {
        locationManager.startUpdatingLocation()
    }

    func stopRecord() {
        locationManager.stopUpdatingLocation()
    }
    
    func setRoute(_ route: [CLLocation]) {
        deviceLocationHistory = route
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }

    func updateRoute(_ oldValue: [CLLocation]? = nil) {
        let coordinates = deviceLocationHistory.map {
            $0.coordinate
        }

        let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
        route.title = "Ваш маршрут"

        if previousRoute != nil {
            mapView?.removeOverlay(previousRoute!)
        }
        mapView?.addOverlay(route)
        previousRoute = route
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

extension ActivityRouteController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polyline)
            render.fillColor = UIColor.blue
            render.strokeColor = UIColor.blue
            render.lineWidth = 5

            return render
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKUserLocation {
            let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: deviceLocationIdentifier)


            let view = dequedView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: deviceLocationIdentifier)

            view.image = UIImage(named: "ActiveDeviceLocation")
            
            return view
        }
        
        return nil
    }
}
