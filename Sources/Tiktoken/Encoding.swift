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
    
    private let name: String
    private let patStr: String
    
    init(name: String, patStr: String) {
        self.name = name
        self.patStr = patStr
    }
    
    func encode(value: String) -> [Int] {
        return .init()
    }
    
    func decode(value: [Int]) -> String {
        .init()
    }
}
