//  MapViewController.swift
//  Plans2.0
//  Created by Alex Pallozzi on 3/24/22.

//  MapViewController.swift
//  Plans2.0
//  Created by Alex Pallozzi on 3/24/22.

//  MapViewController.swift

//  Plans2.0

//  Created by Alex Pallozzi on 3/24/22.

import UIKit

import MapKit
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    let activeUser : User = User.currentUser;
    var refresher : MapRefresher!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var eventListButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    private var initialSet = false
    private var locationAccess = false
    @IBAction func unwindToMap(_ sender: UIStoryboardSegue) {}
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //User.currentUser = User.createCurrentUser(User.currentUser.userName)
        mapView.delegate = self
        initialSet = false
        determineCurrentLocation()
        mapView.delegate = self
        //adds the annotations to map
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        Task {
            refresher = MapRefresher()
            addMapOverlay(planList: await refresher.refreshUserPlans())
        }
    }
    
    public actor MapRefresher {
        var plans : [Plan]
        
        init () {
            User.currentUser = User.createCurrentUser(User.currentUser.userName)
            plans = User.currentUser.plans;
        }
        func refreshUserPlans() -> [Plan]{
            plans = User.createCurrentUser(User.currentUser.userName).plans
            return plans
            //do nothing for now
        }
    }
    
    
    // location manager extension that gets the user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(initialSet == false) {
            guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
            let initialRegionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let initialRegion = MKCoordinateRegion(center: locationValue, span: initialRegionSpan)
            mapView.setRegion(initialRegion, animated: true)
            initialSet = true;
        }
    }
    
    // adds all the annotations to the map
    func addMapOverlay(planList : [Plan]) {
        for plan in planList {
            let planAnnotation : MKPointAnnotation = MKPointAnnotation()
            loc_coord(plan: plan) { (completion, error) in
                if error == nil {
                    planAnnotation.coordinate = CLLocationCoordinate2DMake(completion.latitude, completion.longitude)
                    planAnnotation.title = plan.title
                    planAnnotation.subtitle = "\(Plan.dayText(plan.day))\n\(Plan.timeText(plan.startTime)) - \(Plan.timeText(plan.endTime))\n\(plan.address!)"
                }
                else {
                    print("error: improper coord")
                }
            }
            mapView.addAnnotation(planAnnotation)
        }
    }
    
    // modifies the map annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.markerTintColor = .systemIndigo
        if annotationView.annotation!.title == "My Location" {
            annotationView.markerTintColor = .systemIndigo
            annotationView.glyphImage = UIImage(named: "bmoicon")
        }
        else if annotationView.annotation!.title!?.localizedCaseInsensitiveContains("birthday") == true || annotationView.annotation!.title!?.localizedCaseInsensitiveContains("birth day") == true {
            print(annotationView.annotation!.title!)
            annotationView.markerTintColor = .systemPink
            annotationView.glyphImage = UIImage(named: "BirthdayCake")
        }
        else if annotationView.annotation!.title!?.localizedCaseInsensitiveContains("basketball") == true || annotationView.annotation!.title!?.localizedCaseInsensitiveContains("basket ball") == true {
            annotationView.markerTintColor = .systemOrange
            annotationView.glyphImage = UIImage(named: "Basketball")
        }
        else {
            print(annotationView.annotation!.title!)

            annotationView.markerTintColor = .black
            annotationView.glyphImage = UIImage(named: "connecticon")
        }
        return annotationView
    }
    
    // gets the coordinates of the address
    private func loc_coord(plan: Plan, completionHandler: @escaping (CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(plan.address) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    // helps the location manager access the user location services
    func determineCurrentLocation() {
        if(locationAccess == false) {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationAccess = true;
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
}
