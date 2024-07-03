//
//  CabinPickerView.swift
//  Sero
//
//  Created on 13/6/2024.
//

import SwiftUI
import SeatsAeroAPI

struct CabinPickerView: View {
    @Binding var selectedCabin: Cabin?
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            Section {
                Button(action: {
                    selectedCabin = nil
                    dismiss()
                }) {
                    HStack {
                        Text("All cabins")
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(selectedCabin == nil ? 1.0 : 0.0)
                    }
                }
                .foregroundColor(.primary)
            }
            Section {
                ForEach(Cabin.allCases, id: \.self) { item in
                    Button(action: {
                        selectedCabin = item
                        dismiss()
                    }) {
                        HStack {
                            Text(item.rawValue.capitalized)
                            Spacer()
                            Image(systemName: "checkmark")
                                .opacity(selectedCabin == item ? 1.0 : 0.0)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .navigationBarTitle(Text("Cabin"), displayMode: .inline)
    }
}

#Preview {
    struct Preview: View {
        @State var selectedCabin: Cabin? = Cabin.economy
        var body: some View {
            CabinPickerView(selectedCabin: $selectedCabin)
        }
    }
    
    return Preview()
}
