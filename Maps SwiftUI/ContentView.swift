//
//  ContentView.swift
//  Maps SwiftUI vs UIKit
//
//  Created by Cleo Howard on 8/25/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    private let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.1147, longitude: -115.1728),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    private let points = LocationGenerator.generate(
        center: CLLocationCoordinate2D(latitude: 36.1147, longitude: -115.1728),
        count: 30
    )
    
    var body: some View {
        ClusteredMapView(region: region, points: points)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}

