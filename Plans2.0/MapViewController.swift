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
        initialSet = false
        User.currentUser = User.createCurrentUser(User.currentUser.userName)
        determineCurrentLocation()
        //backButton?.addTarget(self, action: #selector(backTap), for: .touchUpInside)
        // refresh annotations if needed
        mapView.delegate = self
        
        mapView.removeAnnotations(mapView.annotations)
        
        addMapOverlay(planList: activeUser.plans)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    
    // location manager extension that gets the user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(initialSet == false) {
            let userLocationPin : MKPointAnnotation = MKPointAnnotation()
            guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
            userLocationPin.title = "YOU"
            userLocationPin.subtitle = "This is you!"
            userLocationPin.coordinate = CLLocationCoordinate2DMake(locationValue.latitude, locationValue.longitude)
            let initialRegionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let initialRegion = MKCoordinateRegion(center: locationValue, span: initialRegionSpan)
            mapView.setRegion(initialRegion, animated: true)
            mapView.addAnnotation(userLocationPin)
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
        for annot in mapView.annotations {
            if annot.title == "My Location" {
                mapView.removeAnnotation(annot)
            }
        }
        if annotation.title == "YOU" || annotation.subtitle == "This is you!" {
            annotationView.markerTintColor = .systemIndigo
            annotationView.glyphImage = UIImage(named: "bmoicon")
        }
        else if annotation.title != "YOU" && annotation.subtitle != "This is you!"{
            annotationView.markerTintColor = .systemOrange
            annotationView.glyphImage = UIImage(named: "connecticon")
        }
        else {
            annotationView.markerTintColor = .systemIndigo
            annotationView.glyphImage = UIImage(named: "bmoicon")
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
            //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}
