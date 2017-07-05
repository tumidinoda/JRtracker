//
//  ViewController.swift
//  JRtracker
//
//  Created by Robert Jonas on 26.06.17.
//  Copyright © 2017 jr-soft. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController:   UIViewController,
    CLLocationManagerDelegate,
    MKMapViewDelegate
{
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var myInfoBox: UILabel!
    var myLocMgr = CLLocationManager()
    var myCoords:[CLLocationCoordinate2D] = []  // Positions-Array
    //-----------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //init location manager
        myLocMgr.delegate = self
        myLocMgr.desiredAccuracy = kCLLocationAccuracyBest
        myLocMgr.requestAlwaysAuthorization()
        myLocMgr.startUpdatingLocation()
        
        // Map-Methoden verarbeiten
        myMapView.delegate = self
        
    }
    //-----------------------------------------------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for loc in locations {
            // Position anzeigen und dem coords-Array hinzufügen
            let long =   String(format: "%.4f", loc.coordinate.longitude)
            let lat  =   String(format: "%.4f", loc.coordinate.latitude)
            let alt =    String(format: "%.1f", loc.altitude)
            let speed =  String(format: "%.1f", loc.speed)
            let course = String(format: "%.1f", loc.course)
            myInfoBox.text = "long= \(long) • lat= \(lat) •  \n" +
                "alt= \(alt) m \n" +
                "speed= \(speed) m/s \n" +
                "course= \(course) •  \n" +
            "time = \(loc.timestamp) \n"
            
            // sichtbaren Bereich der Karte (inkl. Zoom) einstellen
            // aktuelle Position immer zentriert
            let span = 0.01  // in Grad; 1 •  entspricht 111 km,
            // 0.01 •  entspricht 1100 m
            let reg = MKCoordinateRegion(
                center: myMapView.userLocation.coordinate,
                span: MKCoordinateSpanMake(span, span))
            myMapView.setRegion(reg, animated: false)
            
            // Koordinaten speichern
            myCoords.append(loc.coordinate)
            
            // fügt dem Map-Overlay eine Linie vom letzten
            // zum vorletzten Punkt hinzu
            let n = myCoords.count
            
            if n > 4 {  // die ersten Messpunkte ignorieren, oft ungenau
                var pts = [myCoords[n-1], myCoords[n-2]]
                let polyline =
                    MKPolyline(coordinates: &pts, count: pts.count)
                myMapView.add(polyline)
            }
        }
    }
    
    //-----------------------------------------------------------------------------------------------
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            // falls Polyline-Overlay: passenden
            // MKPolylineRenderer erzeugen
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        } else {
            // leere MKOverlayRenderer-Instanz zurückgeben
            return MKOverlayRenderer()
        }
    }
    
    //-----------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

