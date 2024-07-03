//
//  SavedQueryRowView.swift
//  Sero
//
//  Created on 14/6/2024.
//

import SwiftUI
import SeatsAeroAPI

struct SavedQueryRowView: View {
    var viewModel: SavedQueryViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(viewModel.originsDescription) ✈ \(viewModel.destinationsDescription)")
                Spacer()
                Text(viewModel.startAndEndDateDescription)
            }
            
            if false == viewModel.filterHasNoParametersSet {
                Text(viewModel.filterSummaryDescription).font(.caption)
            }
        }.padding(5)
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let query = Query(search: Search(), filter: SearchFilter())
            let viewModel = SavedQueryViewModel(query: query)
            SavedQueryRowView(viewModel: viewModel)
        }
    }
    
    return Preview()
}
