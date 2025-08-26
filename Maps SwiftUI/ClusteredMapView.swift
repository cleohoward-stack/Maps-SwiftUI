//
//  ClusteredMapView.swift
//  Maps SwiftUI vs UIKit
//
//  Created by Cleo Howard on 8/26/25.
//

import MapKit
import SwiftUI

struct ClusteredMapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    let points: [MapPoint]
    
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.setRegion(region, animated: false)
        map.pointOfInterestFilter = .excludingAll
        map.showsCompass = false
        map.showsScale = false
        map.delegate = context.coordinator
        
        map.register(SwiftUIPinView.self, forAnnotationViewWithReuseIdentifier: "pin")
        map.register(CustomClusterView.self, forAnnotationViewWithReuseIdentifier: "cluster")
        
        return map
    }
    
    func updateUIView(_ map: MKMapView, context: Context) {
        let existing = Set(map.annotations.compactMap { ($0 as? MKPointAnnotation)?.title ?? nil })
        let incoming = Set(points.map { $0.id.uuidString })
        
        // Remove old
        map.removeAnnotations(map.annotations.filter {
            guard let a = $0 as? MKPointAnnotation, let title = a.title else { return false }
            return !incoming.contains(title)
        })
        
        // Add new
        for p in points where !existing.contains(p.id.uuidString) {
            let a = MKPointAnnotation()
            a.title = p.id.uuidString
            a.coordinate = p.coordinate
            map.addAnnotation(a)
        }
    }
}

final class MapCoordinator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKClusterAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster", for: annotation) as! CustomClusterView
            view.clusteringIdentifier = "kid"
            view.displayPriority = .defaultLow
            return view
        } else {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "pin", for: annotation) as! SwiftUIPinView
            view.clusteringIdentifier = "kid"
            view.displayPriority = .defaultHigh
            return view
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let cluster = view.annotation as? MKClusterAnnotation else { return }
        
        let zoomRegion = MKCoordinateRegion(
            center: cluster.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(zoomRegion, animated: true)
    }
}
