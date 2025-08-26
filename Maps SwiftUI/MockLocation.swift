//
//  MockLocation.swift
//  Maps SwiftUI vs UIKit
//
//  Created by Cleo Howard on 8/25/25.
//


import SwiftUI
import MapKit

struct MapPoint: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct LocationGenerator {
    static func generate(center: CLLocationCoordinate2D, count: Int) -> [MapPoint] {
        (0..<count).map { _ in
            let lat = center.latitude + Double.random(in: -0.01...0.02)
            let lon = center.longitude + Double.random(in: -0.01...0.02)
            return MapPoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
    }
}
