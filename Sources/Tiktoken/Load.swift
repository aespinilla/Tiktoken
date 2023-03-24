//
//  Load.swift
//  
//
//  Created by Alberto Espinilla Garrido on 22/3/23.
//

import Foundation
import SwiftyPyString

enum Load {
    static func loadTiktokenBpe(url: String) async -> [String: Int] {
        guard let data = try? await Load.fetch(stringUrl: url) else { return [:] }
        return FileDecoder().decode(data)
    }
    
    static func dataGymToMergeableBpeRanks(vocabBpeFile: String, encoderJsonFile: String) async -> [Data: Int] {
        var rankToIntByte = (0..<exponentialPow)
            .filter({ Character($0).isPrintable && !Character($0).isWhitespace })
//            .filter({ Character($0).isPrintable && !String(Character($0)).trimmingCharacters(in: .whitespaces).isEmpty })
        
        var dataGymByteToByte = toDictionary(array: rankToIntByte)
        
        var n = 0
        (0..<exponentialPow)
            .forEach({
                if !rankToIntByte.contains($0) {
                    rankToIntByte.append($0)
                    dataGymByteToByte[Character(exponentialPow + n)] = $0
                    n += 1
                }
            })
        
        let bpeMerges = await getVocab()
        var bpeRanks: [Data: Int] = .init()
        rankToIntByte.enumerated().forEach({
            bpeRanks[Data(Character($0.element).utf8)] = $0.offset
        })
        
        n = bpeRanks.count
        bpeMerges.forEach({
            let first = stringToArray(value: String($0.0), dict: dataGymByteToByte)
            let second = stringToArray(value: String($0.1), dict: dataGymByteToByte)
            let arrayInt = (first + second).map({ UInt8($0) })
            let data = Data(arrayInt)
            bpeRanks[data] = n
            n += 1
        })
        
        return bpeRanks
    }
}

private extension Load {
    static var exponentialPow: Int {
        Int(pow(Double(2), Double(8)))
    }
    
    static func stringToArray(value: String, dict: [Character: Int]) -> [Int] {
        value.compactMap({ dict[$0] })
    }
    
    static func toDictionary(array: [Int]) -> [Character: Int] {
        var result: [Character: Int] = .init()
        array.forEach({
            result[Character($0)] = $0
        })
        return result
    }
    
    static func fetch(stringUrl: String) async throws -> Data? {
        guard let url = URL(string: stringUrl) else { return nil }
        let result = try await URLSession.shared.data(from: url)
        return result.0
    }
    
    static func getVocab() async -> [(String, String)] {
        guard let data = try? await fetch(stringUrl: "https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/vocab.bpe"),
              let vocab = String(data: data, encoding: .utf8)
        else { return [] }
        
        return vocab.split(separator: "\n", omittingEmptySubsequences: true)
            .compactMap({
                guard !$0.starts(with: "#version") else { return nil }
                let line = String($0).split(" ")
                guard let first = line.first, let last = line.last else { return nil }
                return (first, last)
            })
    }
}

struct FileDecoder {
    func decode(_ data: Data) -> [String: Int] {
        guard let decoded = String(data: data, encoding: .utf8) else { return [:] }
        var result: [String: Int] = .init()
        decoded.split(separator: "\n").forEach({
            let lineSplit = $0.split(separator: " ")
            guard let first = lineSplit.first,
                  let key = String(first).base64Decoded(),
                  let value = lineSplit.last
            else {
                return
            }
            result[key] = Int(value)
        })
        return result
    }
}

extension String {
    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .ascii)
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

extension Character {
    var isPrintable: Bool {
        return unicodeScalars.contains(where: { $0.isPrintable })
    }
}
