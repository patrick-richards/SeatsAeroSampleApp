//
//  SourceExtensions.swift
//  Sero
//
//  Created on 13/6/2024.
//

import Foundation
import SeatsAeroAPI

extension Source {
    var relatedCarrier: String {
        switch self {
        case .eurobonus: "SK"
        case .virginatlantic: "VA"
        case .aeromexico: "AM"
        case .american: "AA"
        case .delta: "DL"
        case .etihad: "EH"
        case .united: "UA"
        case .emirates: "EK"
        case .aeroplan: "AC"
        case .alaska: "AS"
        case .velocity: "VA"
        case .qantas: "QF"
        case .jetblue: "B6"
        case .flyingblue: "B6"
        case .lifemiles: "AV"
        case .azul: "AD"
        case .smiles: "TK"
            
        default:
            "Unknown (\(self.rawValue))"
        }
    }
}
