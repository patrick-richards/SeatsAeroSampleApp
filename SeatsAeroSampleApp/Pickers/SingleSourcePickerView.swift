//
//  SingleSourcePickerView.swift
//  Sero
//
//  Created on 17/6/2024.
//

import Foundation
import SwiftUI
import SeatsAeroAPI

struct SingleSourcePickerView: View {
    @Binding var selectedSource: Source
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            Section {
                ForEach(Source.allSources, id: \.rawValue) { item in
                    let isSelected = selectedSource == item
                    Button(action: {
                        selectedSource = item
                        dismiss()
                    }) {
                        HStack {
                            CarrierImageView(carrierIATA: item.relatedCarrier)
                            Text(item.name)
                            Spacer()
                            Image(systemName: "checkmark")
                                .opacity(isSelected ? 1.0 : 0.0)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .navigationTitle("Program")
        .navigationViewStyle(.stack)
    }
}

#Preview {
    struct Preview: View {
        @State var selectedSource = Source.velocity
        var body: some View {
            SingleSourcePickerView(selectedSource: $selectedSource)
        }
    }
    
    return Preview()
}

