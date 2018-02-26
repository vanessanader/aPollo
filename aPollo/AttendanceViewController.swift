//
//  AttendanceViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 12/5/17.
//  Copyright © 2017 Vanessa Nader. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AttendanceViewController: UIViewController ,MKMapViewDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {


        let latitude: CLLocationDegrees =  33.8484798
        
        let longitude: CLLocationDegrees = 35.4920868
        
        
        let latDelta: CLLocationDegrees = 0.03
        
        let lonDelta: CLLocationDegrees = 0.03
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        print(location)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        dropPin.title = "Bechtel"
        map.addAnnotation(dropPin)
        
        
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else{
            print("Location service disabled")
        }
        
    }

    @IBOutlet weak var map: MKMapView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation // note that locations is same as the one in the function declaration
        
        locationManager.stopUpdatingLocation() // to stop putting the screen in the middle
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        
        let latDelta: CLLocationDegrees = 0.03
        
        let lonDelta: CLLocationDegrees = 0.03
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let region = MKCoordinateRegion(center: coordinations, span: span)//this basically tells your map where to look and where from what distance
        
        map.setRegion(region, animated: true)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    @IBAction func checkInButton(_ sender: Any) {
        let locManager = CLLocationManager()
        var currentLocation: CLLocation!

        
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        
        if (currentLocation.coordinate.latitude > 33.84 && currentLocation.coordinate.longitude > 35.48 && currentLocation.coordinate.latitude < 33.85 && currentLocation.coordinate.longitude < 35.493) {
            
            let alert = UIAlertController(title: "Successfully Checked In!", message: "Your attendance will be sent to the professor", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Not in class", message: "Please go to class to confirm attendance", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

}
