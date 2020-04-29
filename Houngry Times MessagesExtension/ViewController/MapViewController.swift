//
//  MapViewController.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/29/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapDelegate: class {
    func mapControllerDidChooseRestaurant(_ controller: MapViewController, restaurant: Restaurant)
}

class MapViewController: UIViewController {
    
    // MARK: IBOutlet's
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    
    weak var mapDelegate: MessagesViewController!
    weak var infoDelegate: MapDelegate?
    var locationManager = CLLocationManager()
    let request = MKLocalSearch.Request()
    var userLatitude = Double()
    var userLongitude = Double()
    var restaurant: Restaurant?
    
    private var allAnnotations = [MKAnnotation]()
    
    private var displayedAnnotations: [MKAnnotation]? {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                mapView.removeAnnotations(currentAnnotations)
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                mapView.addAnnotations(newAnnotations)
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        checkLocationStatus()
    }
}

// MARK: CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    private func setMap() {
        
        mapView.delegate = self
        
        // mklocal request region set
        request.region = centerMap()
        
        // mkrequest query for search, what to show on map
        request.naturalLanguageQuery = "restaurants"
        
        // set local search object
        let localSearch = MKLocalSearch(request: request)
        
        // local search object func that find for us point of interest
        localSearch.start(completionHandler: { [weak self] response, error in
            
            if let err = error {
                print("this is error", err.localizedDescription, err)
                return
            }
            
            // setting annottations on map from search response
            // response have mapitem object that contains all properties we need to provide to custom annotation
            for pinInfo in response!.mapItems {
                self?.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
                
                self?.mapView.reloadInputViews()
                var location = CLLocationCoordinate2D()
                location = CLLocationCoordinate2D(latitude: pinInfo.placemark.coordinate.latitude, longitude: pinInfo.placemark.coordinate.longitude)
                let annottation = CustomAnnotation(coordinate: location, name: pinInfo.name ?? "", phoneNumber: pinInfo.phoneNumber ?? "", address: pinInfo.placemark.thoroughfare ?? "")
                self?.allAnnotations.append(annottation)
                self?.showAllAnnotations()
                self?.mapView.setRegion(self?.centerMap() ?? MKCoordinateRegion(), animated: true)
            }
        })
    }
    
    private func checkLocationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            self.userLatitude = locationManager.location?.coordinate.latitude ?? 0.0
            self.userLongitude = locationManager.location?.coordinate.longitude ?? 0.0
            DispatchQueue.main.async {
                self.mapView.showsUserLocation = true
                self.setMap()
            }
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            self.userLatitude = locationManager.location?.coordinate.latitude ?? 0.0
            self.userLongitude = locationManager.location?.coordinate.longitude ?? 0.0
            DispatchQueue.main.async {
                self.mapView.showsUserLocation = true
                self.setMap()
            }
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            let alert = UIAlertController(title: "Location denied", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLatitude = manager.location?.coordinate.latitude ?? 0.0
        self.userLongitude = manager.location?.coordinate.longitude ?? 0.0
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationStatus()
    }
}

// MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //  how to detect which annotation type was tapped on for its callout.
        if let annotation = view.annotation as? CustomAnnotation {
            let restaurant = Restaurant(name: annotation.title, address: annotation.address, phoneNumber: annotation.subtitle, resDate: nil)
            infoDelegate?.mapControllerDidChooseRestaurant(self, restaurant: restaurant)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
         // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? CustomAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
        }
        return annotationView
    }
    
    private func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        
        let identifier = NSStringFromClass(CustomAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = UIColor(named: "internationalOrange")
            
            /*
             Add a detail disclosure button to the callout, which will open a new view controller or a popover.
             When the detail disclosure button is tapped, use mapView(_:annotationView:calloutAccessoryControlTapped:)
             to determine which annotation was tapped.
             */
            let rightButton = UIButton(type: .contactAdd)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        
        return view
    }
    
    private func showAllAnnotations() {
        displayedAnnotations = allAnnotations
    }
    
    private func centerMap() -> MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 3000, longitudinalMeters: 3000)
        return region
    }
}
