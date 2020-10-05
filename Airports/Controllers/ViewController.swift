//
//  ViewController.swift
//  Airports
//
//  Created by Никита on 04/10/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import MapKit

enum Directions {
    case from, to
}

class ViewController: UIViewController, AirportsDelegate {
    
    private var direction: Directions = .from
    
    private var fromAirport: Airport? {
        didSet {
            startRender()
        }
    }
    private var toAirport: Airport? {
        didSet {
            startRender()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var geodesicPopyline: MKGeodesicPolyline!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
    }
    
    @IBAction func chooseButtonTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            // from button
            direction = .from
        }
        else if sender.tag == 2 {
            // to button
            direction = .to
        }
        if let controller = airportsController() {
            controller.delegate = self
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    private func airportsController() -> AirportsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "airportsController") as? AirportsViewController {
            return controller
        }
        fatalError("Opps!!!")
    }
    
    func setAirport(airport: Airport) {
        let text = airport.cityName + " | " + airport.countryName
        switch direction {
        case .from:
            // найти кнопку программно в иерархии вью и установить для нее значение
            view.subviews.forEach { subview in
                if let button = subview as? UIButton {
                    if button.tag == 1 {
                        button.setTitle(text, for: .normal)
                    }
                }
            }
            fromAirport = airport
        case .to:
            // найти кнопку программно в иерархии вью и установить для нее значение
            view.subviews.forEach { subview in
                if let button = subview as? UIButton {
                    if button.tag == 2 {
                        button.setTitle(text, for: .normal)
                    }
                }
            }
            toAirport = airport
        }
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
    }
    
    private func startRender() {
        guard
            let from = fromAirport,
            let to = toAirport else {
                return
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let first = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let second = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        let fAnnotation = AirportAnnotation(coordinate: first.coordinate)
        let sAnnotation = AirportAnnotation(coordinate: second.coordinate)
        
        var coordinates = [first.coordinate, second.coordinate]
        
        let geodesicPopyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        self.geodesicPopyline = geodesicPopyline
        
        mapView.addAnnotations([fAnnotation, sAnnotation])
        mapView.addOverlay(geodesicPopyline)
        
        mapView.fitMapViewToAnnotionsList(with: UIEdgeInsets(top: 300, left: 40, bottom: 150, right: 40))
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard
            let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 5.0
        renderer.alpha = 0.7
        renderer.strokeColor = .blue
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }
        else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(systemName: "pencil.circle.fill")
        return annotationView
    }
    
}
