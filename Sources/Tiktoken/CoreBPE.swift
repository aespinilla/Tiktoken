//
//  CoreBPE.swift
//  
//
//  Created by Alberto Espinilla Garrido on 23/3/23.
//

import Foundation

class CoreBPE {
    private let encoder: [[UInt8]: Int]
    private let specialTokensEncoder: [String: Int]
    private let decoder: [Int: [UInt8]]
    private let specialTokensDecoder: [Int: Data]
    private let regexTls: [NSRegularExpression]
    private let specialRegexTls: [NSRegularExpression]
    private let sortedTokenBytes: [Data]
    
    init(encoder: [[UInt8] : Int] = .init(),
         specialTokensEncoder: [String : Int] = .init(),
         decoder: [Int : [UInt8]] = .init(),
         specialTokensDecoder: [Int : Data] = .init(),
         regexTls: [NSRegularExpression] = .init(),
         specialRegexTls: [NSRegularExpression] = .init(),
         sortedTokenBytes: [Data] = .init()) {
        self.encoder = encoder
        self.specialTokensEncoder = specialTokensEncoder
        self.decoder = decoder
        self.specialTokensDecoder = specialTokensDecoder
        self.regexTls = regexTls
        self.specialRegexTls = specialRegexTls
        self.sortedTokenBytes = sortedTokenBytes
    }
    
    func encodeOrdinaryNative(text: String) -> [Int] {
        let regex = regexTls.first!
        var ret = [Int]()
        for mat in regex.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
            if let range = Range(mat.range, in: text) {
                let piece = Array(text[range].utf8)
                if let token = encoder[piece] {
                    ret.append(token)
                    continue
                }
                let encoded = bytePairEncode([UInt8](piece), encoder)
                ret.append(contentsOf: encoded)
            }
        }
        return ret
    }
    
    func decodeNative(tokens: [Int]) -> String {
        let data = tokens.reduce(into: Data(), {
            if let tokenBytes = decoder[$1] {
                $0.append(contentsOf: tokenBytes)
            }
        })
        return String(data: data, encoding: .utf8) ?? ""
    }
}

private extension CoreBPE {
//    func _get_tl_regex() -> NSRegularExpression {
//        regexTls[hash_current_thread() % MAX_NUM_THREADS]
//    }
//
//    func _get_tl_special_regex() -> NSRegularExpression {
//        specialRegexTls[hash_current_thread() % MAX_NUM_THREADS]
//    }
//    func encodeNative(text: String, allowedSpecial: Set<String>) -> ([Int], Int) {
//        let specialRegex = specialRegexTls.first!
//        let regex = regexTls.first!
//        var ret = [Int]()
//        var start = 0
//        var lastPieceTokenLen = 0
//
//        var newEncoder = [[UInt8]: Int]()
//        encoder.forEach({
//            newEncoder[[UInt8]($0.key)] = $0.value
//        })
//
//        while true {
//            var nextSpecial: NSTextCheckingResult?
//            var startFind = start
//
//            while true {
//                // Find the next allowed special token, if any
//                nextSpecial = specialRegex.firstMatch(in: text, range: NSRange(startFind..<text.utf16.count))
//                if nextSpecial == nil { break }
//
//                let range = Range(nextSpecial!.range)
//                if allowedSpecial.contains(text.substring(with: range!)) {
//                    break
//                }
//                startFind = nextSpecial!.range.location + 1
//            }
//
//            let end = nextSpecial?.range.location ?? text.utf16.count
//
//            let currentText = text.substring(with: start..<end)
//            for mat in regex.matches(in: currentText, range: NSRange(text.startIndex..., in: currentText)) {
////                let piece = mat.group(at: 0)!.asBytes()
//                let piece = Range(mat.range, in: text).map({ String(text[$0]) })?.data(using: .utf8) ?? Data() // WARNING
//                if let token = encoder[piece] {
//                    lastPieceTokenLen = 1
//                    ret.append(token)
//                    continue
//                }
//                let tokens = bytePairEncode([UInt8](piece), encoder)
//                lastPieceTokenLen = tokens.count
//                ret.append(contentsOf: tokens)
//            }
//
//            if let m = nextSpecial {
//                let range = Range(m.range)
//                let piece = text.substring(with: range!)
//                let token = specialTokensEncoder[piece]!
//                ret.append(token)
//                start = m.range.location + m.range.length
//                lastPieceTokenLen = 0
//            } else { break }
//        }
//        return (ret, lastPieceTokenLen)
//    }
    
    func increaseLastPieceTokenLen(tokens: [Int], lastPieceTokenLen: Int) -> ([Int], Int) {
        func tokenIsAllSpace(_ token: Int) -> Bool {
            guard let tokenBytes = decoder[token] else { return false }
            return tokenBytes.reversed().allSatisfy { [32, 10, 9].contains($0) } // WARNING: .all(|&b| [b' ', b'\n', b'\t'].contains(&b))
        }

        var lastPieceTokenLen = lastPieceTokenLen
        if lastPieceTokenLen > 0 && tokenIsAllSpace(tokens[tokens.count - lastPieceTokenLen]) {
            while lastPieceTokenLen < tokens.count && tokenIsAllSpace(tokens[tokens.count - lastPieceTokenLen - 1]) {
                lastPieceTokenLen += 1
            }
        }

        assert(lastPieceTokenLen <= tokens.count)
        return (tokens, lastPieceTokenLen)
    }

//    func encodeUnstableNative(_ text: String, _ allowed_special: Set<String>) -> ([Int], Set<[Int]>) {
//        let (tokens1, lastPieceTokenLen1) = encodeNative(text: text, allowedSpecial: allowed_special)
//        guard lastPieceTokenLen1 > 0 else {
//            return (tokens1, Set())
//        }
//        
//        var (tokens, lastPieceTokenLen) = increaseLastPieceTokenLen(tokens: tokens1, lastPieceTokenLen: lastPieceTokenLen1)
//        
//        let unstableBytes = decodeNative(tokens: Array(tokens.suffix(lastPieceTokenLen)))
//        tokens.removeLast(lastPieceTokenLen)
//        var completions = Set<[Int]>()
//        guard !unstableBytes.isEmpty else {
//            return (tokens, completions)
//        }
//        
//        var newEncoder = [[UInt8]: Int]()
//        encoder.forEach({
//            newEncoder[[UInt8]($0.key)] = $0.value
//        })
//        
//        var point = sortedTokenBytes.partition(by: { $0.prefix($0.count).lexicographicallyPrecedes(unstableBytes.prefix(unstableBytes.count)) })
//        while point < sortedTokenBytes.count && sortedTokenBytes[point].starts(with: unstableBytes) {
//            completions.insert([encoder[sortedTokenBytes[point]]!])
//            point += 1
//        }
//        
//        for i in 1..<unstableBytes.count {
//            let prefix = Array(unstableBytes.prefix(i))
//            let suffix = Array(unstableBytes.suffix(from: i))
////            var point = sortedTokenBytes.partitionPoint { x in x < suffix }
//            
//            var point = sortedTokenBytes.partition(by: { $0.prefix($0.count).lexicographicallyPrecedes(suffix.prefix(suffix.count)) })
//            while point < sortedTokenBytes.count && sortedTokenBytes[point].starts(with: suffix) {
//                let possibility = prefix + sortedTokenBytes[point]
//                let encoded: [Int]
//                do {
//                    let s = try String(decoding: possibility, as: UTF8.self)
//                    encoded = encodeOrdinaryNative(text: s)
//                } catch {
//                    encoded = bytePairEncode(possibility, newEncoder)
//                }
//                var seq = [Int]()
//                var seqLen = 0
//                for token in encoded {
//                    seq.append(token)
//                    seqLen += decoder[token]!.count
//                    if seqLen >= unstableBytes.count {
//                        break
//                    }
//                }
//                completions.insert(seq)
//                point += 1
//            }
//        }
//        
////        if unstableBytes.count > 1 {
////            let lastDecoded = unstableBytes.decodeLastUTF8()
////            if unstableBytes.count - lastDecoded.1 > 0 && lastDecoded.0?.isWhitespace == true {
////                var reencoded = bytePairEncode(Array(unstableBytes.prefix(unstableBytes.count - lastDecoded.1)), newEncoder)
////                reencoded += bytePairEncode(Array(unstableBytes.suffix(lastDecoded.1)), newEncoder)
////                completions.insert(reencoded)
////            }
////        }
////
//        if unstableBytes.count > 1 {
//            if let char = unstableBytes.last, let lastDecoded = String(utf8String: [CChar(char)]) {
//                let lastDecodedLength = unstableBytes.count - lastDecoded.count
//                if lastDecodedLength > 0 && lastDecoded.last?.isWhitespace == true {
//                    let encoded1 = bytePairEncode(Array(unstableBytes.prefix(unstableBytes.count - lastDecodedLength)), newEncoder)
//                    let encoded2 = bytePairEncode(Array(unstableBytes.suffix(lastDecodedLength)), newEncoder)
//                    let reencoded = Array(encoded1) + Array(encoded2)
//                    completions.insert(reencoded)
//                }
//            }
//        }
//
//        
//        return (tokens, completions)
//    }

//    private func _increase_last_piece_token_len(_ tokens: [Int], _ lastPieceTokenLen: Int) -> ([Int], Int) {
//        var lastPieceTokenLen = lastPieceTokenLen
//        let tokenIsAllSpace: (Int) -> Bool = { token in
//            decoder[token]?.reversed().allSatisfy { b in [b" ", b"\n", b"\t"].contains(b) } ?? false
//        }
//
//        if lastPieceTokenLen > 0 && tokenIsAllSpace(tokens[tokens.count - lastPieceTokenLen]) {
//            while lastPieceTokenLen < tokens.count && tokenIsAllSpace(tokens[tokens.count - lastPieceTokenLen - 1]) {
//                lastPieceTokenLen += 1
//            }
//        }
//
//        assert(lastPieceTokenLen <= tokens.count)
//        return (tokens, lastPieceTokenLen)
//    }

}

// MARK: - Merges

private extension CoreBPE {
    func bytePairMerge<T>(_ piece: [UInt8], _ ranks: [[UInt8]: Int ], completion: (Range<Int>) -> T) -> [T] {
        // This is a vector of (start, rank).
        // The rank is of the byte pair starting at position start.
        // The rank of the last item in the vector is not a valid value.
        var parts = (0..<piece.count + 1).map { ($0, Int.max) }
        
        let getRank: ([ (Int, Int) ], Int, Int) -> Int? = { parts, startIdx, skip in
            let calculatedIndex = startIdx + skip + 2
            if calculatedIndex < parts.count {
                let range = parts[startIdx].0..<parts[calculatedIndex].0
                let subPiece = Array(piece[range])
                return ranks[subPiece]
            } else {
                return nil
            }
        }
        
        // We look up the ranks once in the beginning and iteratively update
        // them during each merge, which reduces the number of rank lookups.
        for i in 0..<(parts.count - 2) {
            if let rank = getRank(parts, i, 0) {
                assert(rank != Int.max)
                parts[i].1 = rank
            }
        }
        
        // If you have n parts and m merges, this does O(mn) work.
        // We could do something with a heap and do O(m log n) work.
        // It is important to consider that n is often small (<100), and as such
        // the cache-locality benefits outweigh the algorithmic complexity downsides
        // of the `parts` vector data structure above.

        // Note that we hash bytes, not token pairs. As long as we train BPE the way we
        // currently do, this is equivalent. An easy way to break this would be to decouple
        // merge priority from token index or to prevent specific token merges.
        while parts.count > 1 {
            // usize::MAX is a sentinel rank value allowing us to
            // take the min more quickly
            var minRank = (Int.max, 0)
            for (i, ( _, rank)) in parts.enumerated() {
                if rank < minRank.0 {
                    minRank = (rank, i)
                }
            }
            
            if minRank.0 != Int.max {
                let i = minRank.1
                
                // NOTE: We are about to remove parts[i + 1]. We do not do it
                // yet because there are cache-locality benefits to updating
                // parts[i] and parts[i-1] before removing, which could thrash
                // the cache. Thus, we update the rank calculation by skipping over
                // parts[i + 1], by invoking `get_rank!` with `skip = 1`.
                parts[i].1 = getRank(parts, i, 1) ?? Int.max
                if i > 0 {
                    parts[i - 1].1 = getRank(parts, i - 1, 1) ?? Int.max
                }
                parts.remove(at: i + 1)
            } else {
                break
            }
        }
        
        // TODO: Use ranks
        return parts.prevCurrent({ completion($0.0..<$1.0) })
    }
    
    func bytePairEncode(_ piece: [UInt8], _ ranks: [[UInt8]: Int]) -> [Int] {
        if piece.count == 1 {
            return [ranks[piece]!]
        }
        return bytePairMerge(piece, ranks, completion: { p in
            let chunk = Array(piece[p])
            return ranks[chunk] ?? 0
        })
    }
    
//    func bytePairSplit(_ piece: [UInt8], _ ranks: [[UInt8]: Int]) -> [[UInt8]] {
//        if piece.count == 1 {
//            return [piece]
//        }
//        return bytePairMerge(piece, ranks, completion: { Array(piece[$0]) })
//    }
}

extension Array {
    func prevCurrent<T>(_ body: (Element, Element) throws -> T) rethrows -> [T] {
        enumerated().compactMap({ index, element in
            guard index > 0 else { return nil }
            let prev = self[index-1]
            return try? body(prev, element)
        })
    }
}
