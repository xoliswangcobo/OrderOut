//
//  MapViewController.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/30.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        self.title = business.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go", style: .plain, target: self, action: #selector(go))
        self.mapView.delegate = self
        
        let businessAnnotation = MKPointAnnotation.init()
        businessAnnotation.coordinate = CLLocationCoordinate2D.init(latitude: self.business.geometry.location.lat, longitude: self.business.geometry.location.lng)
        businessAnnotation.title = self.business.name
        businessAnnotation.subtitle = self.business.vicinity
        self.mapView.addAnnotation(businessAnnotation)
            
        let region = MKCoordinateRegion(center: businessAnnotation.coordinate, latitudinalMeters: CLLocationDistance(AppConstants.mapRegionBoundaryDistance), longitudinalMeters: CLLocationDistance(AppConstants.mapRegionBoundaryDistance))
        self.mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        self.mapView.setRegion(region, animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: CLLocationDistance(AppConstants.cameraMaxCenterCoordinateDistance))
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    @objc func  go() {
        self.showNavigationActions()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else {
          return nil
        }
        
        let identifier = "business"
        var view: MKMarkerAnnotationView
        
        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView?.tintColor = .primary
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard (view.annotation as? MKPointAnnotation) != nil else {
          return
        }
        
        self.showNavigationActions()
    }
}

extension MapViewController {

    func showNavigationActions() {
        let alertViewController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let attributedTitle = NSAttributedString(string: "Navigate", attributes: [ .foregroundColor : UIColor.primary ])
        let attributedMessage = NSAttributedString(string: "", attributes: [ .foregroundColor : UIColor.primary ])
        
        alertViewController.setValuesForKeys(["attributedTitle" : attributedTitle, "attributedMessage" : attributedMessage])
        
        let navigationMapButton = UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            
            let mapItem = MKMapItem(placemark: MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: self.business.geometry.location.lat, longitude: self.business.geometry.location.lng)))
            mapItem.name = self.business.name

            let launchOptions = [ MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving ]
            
            mapItem.openInMaps(launchOptions: launchOptions)
        })
        
        alertViewController.addAction(navigationMapButton)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(cancel)
        
        alertViewController.view.tintColor = .primary
        present(alertViewController, animated: true)
    }
}
