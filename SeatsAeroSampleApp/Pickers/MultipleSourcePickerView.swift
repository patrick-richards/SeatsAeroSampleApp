//
//  MultipleSourcePickerView.swift
//  Sero
//
//  Created on 14/6/2024.
//

import Foundation
import SwiftUI
import SeatsAeroAPI

struct MultipleSourcePickerView: View {
    @Binding var selectedSources: [Source]
    
    var body: some View {
        List {
            Section {
                Button(action: {
                    selectedSources.removeAll()
                }) {
                    HStack {
                        Text("All programs")
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(selectedSources.count == 0 ? 1.0 : 0.0)
                    }
                }
                .foregroundColor(.primary)
            }
            Section {
                ForEach(Source.allSources, id: \.rawValue) { item in
                    let isSelected = selectedSources.contains(where: {$0 == item})
                    Button(action: {
                        if isSelected {
                            selectedSources.removeAll(where: { $0 == item})
                        } else {
                            selectedSources.append(item)
                        }
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
        .navigationTitle("Programs")
        .navigationViewStyle(.stack)
    }
}

#Preview {
    struct Preview: View {
        @State var selectedSources = [Source]()
        var body: some View {
            MultipleSourcePickerView(selectedSources: $selectedSources)
        }
    }
    
    return Preview()
}
