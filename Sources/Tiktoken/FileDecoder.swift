//
//  FileDecoder.swift
//  
//
//  Created by Alberto Espinilla Garrido on 3/4/23.
//

import Foundation

struct FileDecoder {
    func decode(_ data: Data) -> [[UInt8]: Int] {
        guard let decoded = String(data: data, encoding: .utf8) else { return [:] }
        var result: [[UInt8]: Int] = .init()
        decoded.split(separator: "\n").forEach({
            let lineSplit = $0.split(separator: " ")
            guard let first = lineSplit.first,
                  let key = String(first).base64Decoded(),
                  let value = lineSplit.last
            else {
                return
            }
            result[key.uInt8] = Int(value)
        })
        return result
    }
}
