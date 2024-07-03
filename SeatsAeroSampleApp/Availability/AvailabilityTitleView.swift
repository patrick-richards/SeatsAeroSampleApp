//
//  AvailabilityTitleView.swift
//  Sero
//
//  Created on 13/6/2024.
//

import SwiftUI
import SeatsAeroAPI

struct AvailabilityTitleView: View {
    var viewModel: AvailabilityViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .top) {
                Text("\(viewModel.origin) ✈ \(viewModel.destination)")
                    .font(.title2)
                Spacer()
                Text(viewModel.date, style: Text.DateStyle.date)
                    .font(.callout)
            }
            HStack {
                CarrierImageView(carrierIATA: viewModel.sourceCarrier)
                Text("\(viewModel.sourceName)")
                    .font(.caption).foregroundColor(Color(white: 0.2))
            }
        }
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let sampleAvailabilityResponse = Availability.sampleAvailabilityResponse()
            let availability = sampleAvailabilityResponse.availabilities[1]
            let viewModel = AvailabilityViewModel(availability: availability)
            AvailabilityTitleView(viewModel: viewModel)
        }
    }
    
    return Preview()
}
