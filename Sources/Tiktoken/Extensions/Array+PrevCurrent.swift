//
//  Array+PrevCurrent.swift
//  
//
//  Created by Alberto Espinilla Garrido on 10/4/23.
//

import Foundation

extension Array {
    func prevCurrent<T>(_ body: (Element, Element) throws -> T) rethrows -> [T] {
        enumerated().compactMap({ index, element in
            guard index > 0 else { return nil }
            let prev = self[index-1]
            return try? body(prev, element)
        })
    }
}
