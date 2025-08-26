//
//  CustomClusterView.swift
//  Maps SwiftUI vs UIKit
//
//  Created by Cleo Howard on 8/25/25.
//

import SwiftUI
import MapKit

class CustomClusterView: MKAnnotationView {
    private var hostingController: UIHostingController<ClusterBubbleView>?

    override var annotation: MKAnnotation? {
        willSet {
            hostingController?.view.removeFromSuperview()
        }
        didSet {
            guard let cluster = annotation as? MKClusterAnnotation else { return }

            let initials: [String] = cluster.memberAnnotations.compactMap {
                // Extract initial or name from MKPointAnnotation.title
                ($0.title ?? "")?.prefix(1).uppercased()
            }

            let swiftUIView = ClusterBubbleView(initials: initials)
            let host = UIHostingController(rootView: swiftUIView)
            host.view.translatesAutoresizingMaskIntoConstraints = false
            host.view.backgroundColor = .clear

            addSubview(host.view)

            NSLayoutConstraint.activate([
                host.view.centerXAnchor.constraint(equalTo: centerXAnchor),
                host.view.centerYAnchor.constraint(equalTo: centerYAnchor),
                host.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                host.view.heightAnchor.constraint(equalToConstant: 40)
            ])

            self.hostingController = host
        }
    }
}
