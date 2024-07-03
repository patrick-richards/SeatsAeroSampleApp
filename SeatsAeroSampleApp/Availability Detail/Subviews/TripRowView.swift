//
//  TripRowView.swift
//  Sero
//
//  Created on 13/6/2024.
//

import SwiftUI
import SeatsAeroAPI

struct TripRowView: View {
    var trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(spacing: 5) {
                HStack {
                    Spacer()
                    Text(trip.tripAirpotsAsString).font(.title2).multilineTextAlignment(.center)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(trip.pointsAsString).fontWeight(.semibold)
                    Text("+")
                    Text(trip.costAsString)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(trip.remainingSeatsAsString).foregroundStyle(.gray)
                    Spacer()
                }.textScale(.secondary)
                HStack {
                    CarrierImageView(carrierIATA: trip.source.relatedCarrier)
                    Text("\(trip.source.name)")
                        .font(.caption).foregroundColor(Color(white: 0.2))
                }
            }
            .padding(12)
            .background(Color(white: 0.98))
            .cornerRadius(4)
            .shadow(radius: 1.5)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(trip.departsAt, format: .dateTime.hour().minute().withoutTimeZone())
                    Spacer()
                    Image(systemName: "timer")
                    Text(trip.durationAsString)
                    Spacer()
                    Text(trip.arrivesAt, format:
                            .dateTime.hour().minute().withoutTimeZone())
                }
                VStack(alignment: .leading) {
                    ForEach(trip.availabilitySegments, id: \.id) { segment in
                        HStack {
                            CarrierImageView(carrierIATA:  segment.flightCarrier)
                            Text(segment.flightNumber).fontWeight(.semibold)
                            Text(segment.aircraftName).foregroundStyle(.gray)
                            Text("\(trip.cabin.capitalized) (\(segment.fareClass))").foregroundStyle(.gray).fontWeight(.semibold)
                        }
                    }
                }.textScale(.secondary)
            }
            .padding(5)
        }
        .padding([.top, .bottom], 10)
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let sampleTripResponse = Trip.sampleTripResponse()
            let trip = sampleTripResponse.trips[2]
            TripRowView(trip: trip)
        }
    }
    
    return Preview()
}
