//
//  Character+Int.swift
//  
//
//  Created by Alberto Espinilla Garrido on 2/4/23.
//

import Foundation

extension Character {
    init(_ i: Int) {
        self.self = Character(UnicodeScalar(i)!)
    }
    
    var isPrintable: Bool {
        unicodeScalars.contains(where: { $0.isPrintable })
    }
}

extension Unicode.Scalar {
    var isPrintable: Bool {
        switch properties.generalCategory {
        case .control, .format: return false
        default: return true
        }
    }
}
