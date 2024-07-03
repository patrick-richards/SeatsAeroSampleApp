//
//  AvailabilitySearchFilterView.swift
//  Sero
//
//  Created on 14/6/2024.
//

import Foundation
import SwiftUI

struct AvailabilitySearchFilterView: View {
    @State var viewModel: AvailabilitySearchView.FilterViewModel
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: MultipleSourcePickerView(selectedSources: $viewModel.filter.sources)) {
                    HStack {
                        Text("Programs")
                        Spacer()
                        Text(viewModel.sourcesSummaryDescription)
                    }
                }
            }
            
            Section {
                HStack {
                    Toggle("Direct only", isOn: $viewModel.filter.directOnly)
                }
            }
            
            Section {
                HStack {
                    VStack {
                        Text("Operating carriers")
                    }
                    Spacer()
                    TextField("VA, DL, ...", text: $viewModel.filter.operatingCarriers)
                        .multilineTextAlignment(.trailing)
                        .textCase(.uppercase)
                        .disableAutocorrection(true)
                }
            } footer: {
                Text("Comma separated, i.e. VA, DL")
            }
            
            Section {
                HStack {
                    Picker("Minimum available seats", selection: $viewModel.filter.minimumSeats) {
                        ForEach(1...9, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                }
            }
            
            Section {
                Button(action: {
                    viewModel.resetFilter()
                }) {
                    HStack {
                        Spacer()
                        Text("Reset").fontWeight(.semibold)
                        Image(systemName: "arrow.uturn.forward.circle").fontWeight(.semibold)
                        Spacer()
                    }
                }
                .foregroundColor(.red)
            }
        }
        .navigationBarTitle(Text("Filters"), displayMode: .inline)
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let viewModel = AvailabilitySearchView.FilterViewModel()
            
            NavigationView {
                AvailabilitySearchFilterView(viewModel: viewModel)
            }
        }
    }
    
    return Preview()
}
