//
//  AirportPickerView.swift
//  Sero
//
//  Created on 13/6/2024.
//

import SwiftUI
import SeatsAeroAPI

enum AirportPickerViewMode {
    case origin
    case destination
}

struct AirportPickerView: View {
    var mode: AirportPickerViewMode
    
    @State var allAirports: [Airport]
    @Binding var selectedAirports: [Airport]
    
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                HStack() {
                    Text(selectionDescription())
                        
                    Spacer()
                    if false == selectedAirports.isEmpty {
                        Button(action: {
                            selectedAirports.removeAll()
                        }) {
                                Image(systemName: "xmark.circle").fontWeight(.semibold)
                        }.foregroundColor(.red)
                    }
                }
                .padding([.leading, .trailing], 25)
                .padding([.top, .bottom], 10)
                Divider()
            }
            
            List(searchResults, id: \.iata) { airport in
                let isSelected = selectedAirports.contains(where: { $0 == airport })
                HStack {
                    VStack(alignment: .leading) {
                        Text(airport.iata).fontWeight(.semibold)
                        Text(airport.name)
                    }
                    Spacer()
                    Image(systemName: "checkmark")
                        .opacity(isSelected ? 1.0 : 0.0)
                }
                .padding(.bottom, 5)
                .onTapGesture {
                    if isSelected {
                        selectedAirports.removeAll(where: { $0 == airport })
                    } else {
                        selectedAirports.append(airport)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search airports")
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var searchResults: [Airport] {
        if searchText.isEmpty {
            allAirports
        } else {
            allAirports.filter { $0.iata.contains(searchText) || $0.iata == searchText.uppercased() || $0.name.contains(searchText) }
        }
    }
    
    func selectionDescription() -> String {
        if selectedAirports.count == 0 {
            return "No " + (mode == .origin ? "origin" : "destination") + " selected"
        }
        
        var selectionDescription = ""
        if mode == .origin {
            selectionDescription = "Departing from"
        } else {
            selectionDescription = "Arriving at"
        }
        
        var airportsDescription = ""
        if selectedAirports.count == 1 {
            airportsDescription = selectedAirports[0].iata
        } else if selectedAirports.count == 2 {
            airportsDescription = "\(selectedAirports[0].iata) or \(selectedAirports[1].iata)"
        } else {
            let allButLastAirportsString = selectedAirports.dropLast().map { $0.iata }.joined(separator: ", ")
            airportsDescription = "\(allButLastAirportsString), or \(selectedAirports.last!.iata)"
        }
        
        return "\(selectionDescription) \(airportsDescription)"
    }
}

#Preview {
    struct Preview: View {
        @State var searchText = ""
        @State var airports = [
            Airport.withIdentifier("MEL")!,
            Airport.withIdentifier("SYD")!,
            Airport.withIdentifier("BNE")!
        ]
        let allAirports = Airport.allAirports()
        
        var body: some View {
            AirportPickerView(mode: .origin, allAirports: allAirports, selectedAirports: $airports)
        }
    }
    
    return Preview()
}
