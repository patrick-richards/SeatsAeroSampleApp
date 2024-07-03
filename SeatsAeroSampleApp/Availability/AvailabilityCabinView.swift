//
//  AvailabilityCabinView.swift
//  Sero
//
//  Created on 13/6/2024.
//

import SwiftUI
import SeatsAeroAPI

struct AvailabilityCabinView: View {
    var viewModel: AvailabilityCabinViewModel
    
    var body: some View {
        HStack {
            Text("\(viewModel.cabinName)").fontWeight(.semibold)
            Text("\(viewModel.availabilityFormatted)")
            if viewModel.hasDirectAvailability {
                Text("Direct")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .font(.callout)
                    .padding(.bottom, 2)
                    .padding([.leading, .trailing], 6)
                    .background(Color.blue)
                    .cornerRadius(4)
            }
        }
        .textScale(.secondary)
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let sampleAvailabilityResponse = Availability.sampleAvailabilityResponse()
            let availability = sampleAvailabilityResponse.availabilities[4]
            let viewModel = AvailabilityCabinViewModel(availability: availability, cabin: .business)
            AvailabilityCabinView(viewModel: viewModel)
        }
    }
    
    return Preview()
}
