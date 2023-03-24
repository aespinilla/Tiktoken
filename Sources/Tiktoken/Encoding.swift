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
    
    private let name: String
    private let patStr: String // Regex
    private let mergeableRanks: [Int: Int]
    private let specialTokens: [String: Int]
    
    private let maxValueToken: Int
    
    init(name: String, patStr: String, mergeableRanks: [Int: Int], specialTokens: [String: Int], explicitNVocab: [Int]? = nil) {
        self.name = name
        self.patStr = patStr
        self.mergeableRanks = mergeableRanks
        self.specialTokens = specialTokens
        self.maxValueToken = max(mergeableRanks.values.max() ?? 0, specialTokens.values.max() ?? 0)
  
        // Assert validation
        
//        if explicit_n_vocab:
//            assert len(mergeable_ranks) + len(special_tokens) == explicit_n_vocab
//            assert self.max_token_value == explicit_n_vocab - 1
        
        
    }
    
    func encode(value: String) -> [Int] {
        return .init()
    }
    
    func decode(value: [Int]) -> String {
        .init()
    }
}
