//
//  RegionPickerView.swift
//  Sero
//
//  Created on 17/6/2024.
//

import SwiftUI
import SeatsAeroAPI

enum RegionPickerViewMode: String {
    case origin = "Origin"
    case destnation = "Destination"
}

struct RegionPickerView: View {
    var mode: RegionPickerViewMode
    @Binding var selectedRegion: Region?
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            Section {
                Button(action: {
                    selectedRegion = nil
                    dismiss()
                }) {
                    HStack {
                        Text("Anywhere")
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(selectedRegion == nil ? 1.0 : 0.0)
                    }
                }
                .foregroundColor(.primary)
            }
            Section {
                ForEach(Region.allCases, id: \.self) { item in
                    Button(action: {
                        selectedRegion = item
                        dismiss()
                    }) {
                        HStack {
                            Text(item.rawValue)
                            Spacer()
                            Image(systemName: "checkmark")
                                .opacity(selectedRegion == item ? 1.0 : 0.0)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .navigationBarTitle(Text(mode.rawValue), displayMode: .inline)
    }
}

#Preview {
    struct Preview: View {
        @State var selectedRegion: Region? = nil
        var body: some View {
            RegionPickerView(mode: .origin, selectedRegion: $selectedRegion)
        }
    }
    
    return Preview()
}
