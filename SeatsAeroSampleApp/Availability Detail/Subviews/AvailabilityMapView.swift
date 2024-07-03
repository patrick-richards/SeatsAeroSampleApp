//
//  AvailabilityMapView.swift
//  Sero
//
//  Created on 18/6/2024.
//

import Foundation
import SwiftUI
import SeatsAeroAPI
import MapKit

struct AvailabilityMapView: View {
    var viewModel: ViewModel
    @State private var trigger = false
    
    var body: some View {
        VStack {
            Map(interactionModes: [.zoom, .pan]) {
                MapPolyline(coordinates: [viewModel.origin.coordinate, viewModel.destination.coordinate], contourStyle: .straight)
                    .stroke(.blue, lineWidth: 2)
                Marker(viewModel.origin.iata, systemImage: "airplane.departure", coordinate: viewModel.origin.coordinate)
                Marker(viewModel.destination.iata, systemImage: "airplane.arrival", coordinate: viewModel.destination.coordinate)
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .mapCameraKeyframeAnimator(trigger: trigger) { initialCamera in
                KeyframeTrack(\.distance) {
                    CubicKeyframe(initialCamera.distance * 1.35, duration: 0.0)
                    CubicKeyframe(initialCamera.distance * 1.01, duration: 3.0)
                }
            }
        }
        .task {
            trigger = !trigger
        }
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let sampleAvailabilityResponse = Availability.sampleAvailabilityResponse()
            let availability = sampleAvailabilityResponse.availabilities[0]
            let viewModel = AvailabilityMapView.ViewModel(availability: availability)
            AvailabilityMapView(viewModel: viewModel)
        }
    }
    
    return Preview()
}
