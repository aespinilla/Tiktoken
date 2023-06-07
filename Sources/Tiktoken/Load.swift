//
//  Load.swift
//  
//
//  Created by Alberto Espinilla Garrido on 22/3/23.
//

import Foundation
import CryptoKit

enum Load {
    static func loadTiktokenBpe(url: String, decoder: FileDecoder = FileDecoder()) async -> [[UInt8]: Int] {
        guard let data = try? await Load.fetch(stringUrl: url) else { return [:] }
        return decoder.decode(data)
    }
    
    static func dataGymToMergeableBpeRanks(vocabBpeFile: String, encoderJsonFile: String? = nil) async -> [[UInt8]: Int] {
        var rankToIntByte = (0..<exponentialPow).filter({ Character($0).isPrintable && !Character($0).isWhitespace })
        var dataGymByteToByte: [Character: Int] = toDictionary(array: rankToIntByte)
        
        var n = 0
        (0..<exponentialPow)
            .forEach({
                if !rankToIntByte.contains($0) {
                    rankToIntByte.append($0)
                    dataGymByteToByte[Character(exponentialPow + n)] = $0
                    n += 1
                }
            })
        
        let bpeMerges: [(String, String)] = await getVocab(url: vocabBpeFile)
        var bpeRanks: [[UInt8]: Int] = .init()
        rankToIntByte.enumerated().forEach({
            let key = Array(Character($0.element).utf16).map({ UInt8($0) })
            bpeRanks[key] = $0.offset
        })
        
        n = bpeRanks.count
        bpeMerges.forEach({
            let first = stringToArray(value: $0.0, dict: dataGymByteToByte)
            let second = stringToArray(value: $0.1, dict: dataGymByteToByte)
            let arrayInt = (first + second).map({ UInt8($0) })
            bpeRanks[arrayInt] = n
            n += 1
        })
        
        // TODO: Validate bpe ranks with json encoder file
        //        assert(bpeRanks.count == 50256, "Must be expected encoder count")
        //        if let validationUrl = encoderJsonFile {
        //            let validationEncoder = await getDecoder(url: validationUrl)
        //            assert(bpeRanks.count == 50256, "Must be expected encoder count")
        //            assert(bpeRanks.count == validationEncoder.count -1, "Must be expected encoder count")
        //            assert(bpeRanks == validationEncoder, "Must be expected same encoder")
        //        }
        
        return bpeRanks
    }
}

private extension String {
    var sha256: String {
        let data = Data(self.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

private extension Load {

    private static let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!

    static var exponentialPow: Int {
        Int(pow(2.0, 8))
    }
    
    static func stringToArray(value: String, dict: [Character: Int]) -> [Int] {
        value.compactMap({ dict[$0] })
    }
    
    static func toDictionary(array: [Int]) -> [Character: Int] {
        array.reduce(into: [:], { $0[Character($1)] = $1 })
    }
    
    // Fetch data
    static func fetch(stringUrl: String) async throws -> Data? {
        let urlHash = stringUrl.sha256

        // Create a URL for cache file
        let cacheFileURL = cacheDirectoryURL.appendingPathComponent("\(urlHash)")

        // Check if the data exists in cache
        if FileManager.default.fileExists(atPath: cacheFileURL.path) {
            let data = try? Data(contentsOf: cacheFileURL)
            return data
        } else {
            guard let url = URL(string: stringUrl) else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)

            // Save data to cache
            do {
                try data.write(to: cacheFileURL)
            } catch {
                print("Error while caching: \(error)")
            }

            return data
        }
    }
    
    static func getVocab(url: String) async -> [(String, String)] {
        guard let data = try? await fetch(stringUrl: url),
              let vocab = String(data: data, encoding: .utf8)
        else { return [] }
        
        return vocab.split(separator: "\n", omittingEmptySubsequences: true)
            .compactMap({
                guard !$0.starts(with: "#version") else { return nil }
                let line = String($0).splitWhiteSpaces
                guard let first = line.first,
                      let last = line.last
                else { return nil }
                return (first, last)
            })
    }
    
    static func getDecoder(url: String) async -> [String: Int] {
        guard let data = try? await fetch(stringUrl: url),
              let decoded = try? JSONDecoder().decode([String: Int].self, from: data)
        else { return [:] }
        return decoded
    }
}
