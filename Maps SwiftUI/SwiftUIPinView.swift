//
//  SwiftUIPinView.swift
//  Maps SwiftUI vs UIKit
//
//  Created by Cleo Howard on 8/25/25.
//


import MapKit
import SwiftUI

class SwiftUIPinView: MKAnnotationView {
    private var hostingController: UIHostingController<PulsatingAvatar>?

    override var annotation: MKAnnotation? {
        willSet {
            // Remove old hosted view
            hostingController?.view.removeFromSuperview()
            hostingController = nil
        }
        didSet {
            let avatar = PulsatingAvatar()
            let controller = UIHostingController(rootView: avatar)
            controller.view.backgroundColor = .clear
            controller.view.translatesAutoresizingMaskIntoConstraints = false

            addSubview(controller.view)

            NSLayoutConstraint.activate([
                controller.view.centerXAnchor.constraint(equalTo: centerXAnchor),
                controller.view.centerYAnchor.constraint(equalTo: centerYAnchor),
                controller.view.widthAnchor.constraint(equalToConstant: 44),
                controller.view.heightAnchor.constraint(equalToConstant: 44)
            ])

            hostingController = controller
        }
    }
}

#Preview {
    SwiftUIPinView()
}
