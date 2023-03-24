//
//  CoreBPE.swift
//  
//
//  Created by Alberto Espinilla Garrido on 23/3/23.
//

import Foundation

class CoreBPE {
    var encoder: [Data: Int] = .init()
    var specialTokensEncoder: [String: Int] = .init()
    var decoder: [Int: Data] = .init()
    var specialTokensDecoder: [Int: Data] = .init()
    var regexTls: [NSRegularExpression] = .init()
    var specialRegexTls: [NSRegularExpression] = .init()
    var sortedTokenBytes: [Data] = .init()
}

//private extension CoreBPE {
//    func _get_tl_regex() -> NSRegularExpression {
//        regexTls[hash_current_thread() % MAX_NUM_THREADS]
//    }
//    
//    func _get_tl_special_regex() -> NSRegularExpression {
//        specialRegexTls[hash_current_thread() % MAX_NUM_THREADS]
//    }
//    
//    func _decode_native(tokens: [Int]) -> Data {
//        var data = Data()
//        data.reserveCapacity(tokens.count * 2)
//        
//        for token in tokens {
//            guard let tokenBytes = decoder[token] ?? specialTokensDecoder[token] else { break }
//            data.append(tokenBytes)
//        }
//        return data
//    }
//    
//    func _encode_ordinary_native(text: String) -> [Int] {
//        let regex = _get_tl_regex()
//        var ret = [Int]()
//        
//        for mat in regex.findMatches(in: text) {
//            let piece = mat.group(at: 0)!.asBytes()
//            if let token = encoder[piece] {
//                ret.append(token)
//                continue
//            }
//            ret.append(contentsOf: bytePairEncode(piece: piece, encoder: encoder))
//        }
//        return ret
//    }
//    
//    func _encode_native(text: String, allowedSpecial: Set<String>) -> ([Int], Int) {
//        let specialRegex = _get_tl_special_regex()
//        let regex = _get_tl_regex()
//        var ret = [Int]()
//        var start = 0
//        var lastPieceTokenLen = 0
//        
//        while true {
//            var nextSpecial: TextCheckingResult?
//            var startFind = start
//            
//            while true {
//                // Find the next allowed special token, if any
//                nextSpecial = specialRegex.firstMatch(in: text, range: NSRange(startFind..<text.utf16.count))
//                if nextSpecial == nil { break }
//                
//                if allowedSpecial.contains(text[nextSpecial!.range]!) {
//                    break
//                }
//                startFind = nextSpecial!.range.location + 1
//            }
//            
//            let end = nextSpecial?.range.location ?? text.utf16.count
//            
//            for mat in regex.findMatches(in: text[start..<end]) {
//                let piece = mat.group(at: 0)!.asBytes()
//                if let token = encoder[piece] {
//                    lastPieceTokenLen = 1
//                    ret.append(token)
//                    continue
//                }
//                let tokens = bytePairEncode(piece: piece, encoder: encoder)
//                lastPieceTokenLen = tokens.count
//                ret.append(contentsOf: tokens)
//            }
//            
//            if let m = nextSpecial {
//                let piece = text[m.range]!
//                let token = special_tokens_encoder[piece]!
//                ret.append(token)
//                start = m.range.location + m.range.length
//                lastPieceTokenLen = 0
//            } else { break }
//        }
//        return (ret, lastPieceTokenLen)
//    }
//}
//
//// MARK: - Merges
//
//private extension CoreBPE {
//    func _bytePairMerge<T>(_ piece: [UInt8], _ ranks: [ [UInt8] : Int ], _ f: (Range<Int>) -> T) -> [T] {
//        var parts = (0...piece.count).map { ($0, Int.max) }
//        
//        let getRank: ([ (Int, Int) ], Int, Int) -> Int? = {
//            (parts, startIdx, skip) in
//            if (startIdx + skip + 2) < parts.count {
//                let range = parts[startIdx].0...parts[startIdx + skip + 2].0
//                return ranks[Array(piece[range])] ?? nil
//            } else {
//                return nil
//            }
//        }
//        
//        for i in 0..<(parts.count - 2) {
//            if let rank = getRank(parts, i, 0) {
//                assert(rank != Int.max)
//                parts[i].1 = rank
//            }
//        }
//        
//        while parts.count > 1 {
//            var minRank = (Int.max, 0)
//            for (i, ( _, rank)) in parts[..<(parts.count - 1)].enumerated() {
//                if rank < minRank.0 {
//                    minRank = (rank, i)
//                }
//            }
//            
//            if minRank.0 != Int.max {
//                let i = minRank.1
//                parts[i].1 = getRank(parts, i, 1) ?? Int.max
//                if i > 0 {
//                    parts[i - 1].1 = getRank(parts, i - 1, 1) ?? Int.max
//                }
//                parts.remove(at: i + 1)
//            } else {
//                break
//            }
//        }
//        
//        var out = [T]()
//        out.reserveCapacity(parts.count - 1)
//        for i in 0..<(parts.count - 1) {
//            out.append(f(parts[i].0..<parts[i + 1].0))
//        }
//        return out
//    }
//    
//    func bytePairEncode(_ piece: [UInt8], _ ranks: [ [UInt8] : Int ]) -> [Int] {
//        if piece.count == 1 {
//            return [ranks[piece]!]
//        }
//        return _bytePairMerge(piece, ranks) { p in
//            ranks[Array(piece[p])]!
//        }
//    }
//    
//    func bytePairSplit(_ piece: [UInt8], _ ranks: [ [UInt8] : Int ]) -> [[UInt8]] {
//        if piece.count == 1 {
//            return [piece]
//        }
//        return _bytePairMerge(piece, ranks) { p in
//            Array(piece[p])
//        }
//    }
//}
