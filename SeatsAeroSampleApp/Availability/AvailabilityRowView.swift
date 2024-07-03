//
//  AvailabilityRowView.swift
//  Sero
//
//  Created on 13/6/2024.
//

import SwiftUI
import SeatsAeroAPI

struct AvailabilityRowView: View {
    var viewModel: AvailabilityViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            AvailabilityTitleView(viewModel: viewModel)
            VStack(alignment: .leading) {
                ForEach(Cabin.allCases.reversed(), id: \.rawValue) { cabin in
                    if viewModel.hasAvailability(inCabin: cabin) {
                        let cabinViewModel = AvailabilityCabinViewModel(availability: viewModel.availability, cabin: cabin)
                        AvailabilityCabinView(viewModel: cabinViewModel)
                    }
                }
            }
            .padding([.top], 1)
        }
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let sampleAvailabilityResponse = Availability.sampleAvailabilityResponse()
            let availability = sampleAvailabilityResponse.availabilities[10]
            let viewModel = AvailabilityViewModel(availability: availability)
            AvailabilityRowView(viewModel: viewModel)
        }
    }
    
    return Preview()
}
