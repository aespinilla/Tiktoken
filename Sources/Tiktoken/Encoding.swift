//
//  Encoding.swift
//  
//
//  Created by Alberto Espinilla Garrido on 20/3/23.
//

import Foundation

//"""Creates an Encoding object.
//See openai_public.py for examples of how to construct an Encoding object.
//Args:
//    name: The name of the encoding. It should be clear from the name of the encoding
//        what behaviour to expect, in particular, encodings with different special tokens
//        should have different names.
//    pat_str: A regex pattern string that is used to split the input text.
//    mergeable_ranks: A dictionary mapping mergeable token bytes to their ranks. The ranks
//        must correspond to merge priority.
//    special_tokens: A dictionary mapping special token strings to their token values.
//    explicit_n_vocab: The number of tokens in the vocabulary. If provided, it is checked
//        that the number of mergeable tokens and special tokens is equal to this number.
//"""

public class Encoding {
    
//mergeable_ranks: dict[bytes, int],
//special_tokens: dict[str, int],
//explicit_n_vocab: Optional[int] = None,
    
//    let name: String
//    let explicitNVocab: Int?
//    let pattern: String
//    let mergeableRanks: [[UInt8]: Int]
//    let specialTokens: [String: Int] // TODO: Map to [UInt8]
    
    private let name: String
    private let regex: NSRegularExpression // Regex
    private let mergeableRanks: [[UInt8]: Int]
    private let specialTokens: [String: Int]
    private let maxValueToken: Int
    
    private let coreBpe: CoreBPE
    
    init(name: String, regex: NSRegularExpression, mergeableRanks: [[UInt8]: Int], specialTokens: [String: Int], explicitNVocab: Int? = nil) {
        self.name = name
        self.regex = regex
        self.mergeableRanks = mergeableRanks
        self.specialTokens = specialTokens
        self.maxValueToken = max(mergeableRanks.values.max() ?? 0, specialTokens.values.max() ?? 0)
  
        // Assert validation
        
//        if explicit_n_vocab:
//            assert len(mergeable_ranks) + len(special_tokens) == explicit_n_vocab
//            assert self.max_token_value == explicit_n_vocab - 1
        
        let decoder = mergeableRanks.inverted
        self.coreBpe = .init(encoder: mergeableRanks, decoder: decoder, regexTls: [regex])
    }
    
    public func encode(value: String) -> [Int] {
        coreBpe.encodeOrdinaryNative(text: value)
    }
    
    public func decode(value: [Int]) -> String {
        coreBpe.decodeNative(tokens: value)
    }
}
