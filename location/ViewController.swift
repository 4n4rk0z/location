//
//  ViewController.swift
//  location
//
//  Created by 4n4rk0z on 5/22/19.
//  Copyright © 2019 4n4rk0z. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapKit: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the
        mapKit.delegate = self
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        let latDelta: CLLocationDegrees = 5.0
        let lonDelta: CLLocationDegrees = 1.0
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let coordinates = CLLocationCoordinate2D(latitude: 19.4336, longitude: -99.1454)
        
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        mapKit.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.title = "Ciudad de México"
        
        annotation.subtitle = "Me encuentro aqui."
        
        annotation.coordinate = coordinates
        
        mapKit.addAnnotation(annotation)
        
        mapKit.selectAnnotation(annotation, animated: true)
        
        // 19.3948,-99.1736
        let coordinates2 = CLLocationCoordinate2D(latitude: 19.3948, longitude: -99.1736)
        
        let sourcePlacemark = MKPlacemark.init(coordinate: coordinates)
        let sourceMapItem = MKMapItem.init(placemark: sourcePlacemark)
        
        let destinationPlacemark = MKPlacemark.init(coordinate: coordinates2)
        let destinationMapItem = MKMapItem.init(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.mapKit.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapKit.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print("\(location.altitude)")
            print("\(location.coordinate.latitude)")
            print("\(location.coordinate.longitude)")
            print("\(location.coordinate)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error al recuperar los datros de geolocalizacion")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("siempre")
        case .authorizedWhenInUse:
            print("solo en uso")
        case .denied:
            print("negado")
        case .restricted:
            print("restringido")
        case .notDetermined:
            print("mo seleccionado")
        default:
            print("nada")
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.red
        render.lineDashPattern = [2,4]
        render.lineWidth = 4.0
        render.alpha = 1.0
        return render
    }
}
