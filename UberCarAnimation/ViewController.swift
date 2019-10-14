//
//  ViewController.swift
//  UberAnimation
//
//  Created by Mac mini on 11/19/18.
//  Copyright © 2018 Mac mini. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class ViewController: UIViewController {
    
    // MARK :- Variable
    private var myLocationMarker: GMSMarker!
    @IBOutlet weak var mapView: GMSMapView!
    private var carAnimator: CarAnimator!
    override func viewDidLoad() {
        super.viewDidLoad()
		configureMapStyle()
        mapView.drawPath(GMSMapView.pathString)
        LocationTracker.shared.locateMeOnLocationChange { [weak self]  _  in
            self?.moveCarMarker()
        }
    }

    func moveCarMarker() {
        if let myLocation = LocationTracker.shared.lastLocation,
            myLocationMarker == nil {
            myLocationMarker = GMSMarker(position: myLocation.coordinate)
            myLocationMarker.icon = UIImage(named: "car")
            myLocationMarker.map = self.mapView
            carAnimator = CarAnimator(carMarker: myLocationMarker, mapView: mapView)
            self.mapView.updateMap(toLocation: myLocation, zoomLevel: 16)
        } else if let myLocation = LocationTracker.shared.lastLocation?.coordinate, let myLastLocation = LocationTracker.shared.previousLocation?.coordinate {
            carAnimator.animate(from: myLastLocation, to: myLocation)
        }
    }

	// MARK: UI Configuration

	private func configureMapStyle() {
		mapView.mapStyle = mapStyle(traitCollection.userInterfaceStyle)
	}

	// MARK: Helpers

	private func mapStyle(_ style: UIUserInterfaceStyle) -> GMSMapStyle? {
		let styleResourceName = "mapStyle\(style.rawValue)"
		guard let styleURL = Bundle.main.url(forResource: styleResourceName, withExtension: "json") else { return nil }
		let mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
		return mapStyle
	}
}
