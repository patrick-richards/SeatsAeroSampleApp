//
//  CarrierImageView.swift
//  Sero
//
//  Created on 14/6/2024.
//

import SwiftUI

struct CarrierImageView: View {
    @State var carrierIATA: String
    
    var body: some View {
        AsyncImage(url: carrierImageURL()) { phase in
            if let image = phase.image {
                image.resizable()
            } else if phase.error != nil {
                Image(systemName: "airplane.circle")
            } else {
                ProgressView().progressViewStyle(.circular)
            }
        }.frame(width: 25, height: 25)
    }
    
    func carrierImageURL() -> URL {
        return URL(string: "https://www.gstatic.com/flights/airline_logos/70px/\(carrierIATA.uppercased()).png")!
    }
}

#Preview {
    CarrierImageView(carrierIATA: "VA")
}
