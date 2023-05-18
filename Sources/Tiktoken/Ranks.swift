//
//  Ranks.swift
//  
//
//  Created by Alberto Espinilla Garrido on 17/5/23.
//

import Foundation

typealias Ranks = [[UInt8]: Int]

extension Ranks {
    var inverted: [Int: [UInt8]] {
        reduce(into: [:], { $0[$1.value] = $1.key })
    }
}
