//
//  CoreBPETests.swift
//  
//
//  Created by Alberto Espinilla Garrido on 28/3/23.
//

import XCTest
@testable import Tiktoken

final class CoreBPETests: XCTestCase {
    
    private var sut: CoreBPE!

    override func setUpWithError() throws {
        sut = .init()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testEncodeOrdinaryNative() async throws {
//        let input = "This is an example sentence to try encoding out on!"
//        let expected = [1212, 318, 281, 1672, 6827, 284, 1949, 21004, 503, 319, 0]
        let input = "hello 👋 world 🌍"
        let expected = [31373, 50169, 233, 995, 12520, 234, 235]
//
//        let input = "Esto es un texto 👨🏻‍💻 con emojis diferentes 🍿💃🏼🧜‍♂️ y más texto que no tiene sentido 🛟"
//        let expected = [22362, 78, 1658, 555, 2420, 78, 50169, 101, 8582, 237, 119, 447, 235, 8582, 240, 119, 369, 795, 13210, 271, 288, 361, 9100, 274, 12520, 235, 123, 8582, 240, 225, 8582, 237, 120, 8582, 100, 250, 447, 235, 17992, 224, 37929, 331, 285, 40138, 2420, 78, 8358, 645, 46668, 1734, 1908, 17305, 12520, 249, 253]
        

//        let input = "Vamos a probar🚒🚁🚀🚊 muchos emoticonos para probar⚽️🤸🏿‍♀️ diferentes codificaciones 👨🏻‍💻♨︎"
//        let expected = [53, 321, 418, 257, 1861, 283, 8582, 248, 240, 8582, 248, 223, 8582, 248, 222, 8582, 248, 232, 881, 418, 4085, 4749, 418, 31215, 1861, 283, 158, 248, 121, 37929, 8582, 97, 116, 8582, 237, 123, 447, 235, 17992, 222, 37929, 288, 361, 9100, 274, 14873, 811, 49443, 274, 50169, 101, 8582, 237, 119, 447, 235, 8582, 240, 119, 17992, 101, 35266, 236]
        
        
        let encoder = await Load.dataGymToMergeableBpeRanks(vocabBpeFile: "https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/vocab.bpe", encoderJsonFile: "https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/encoder.json")
        let decoder = encoder.reduce(into: [:], { $0[$1.value] = $1.key })
        let regex = try XCTUnwrap(try NSRegularExpression(pattern: "/'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+/gu"))
        sut = .init(encoder: encoder, decoder: decoder, regexTls: [regex])
        let output = sut.encodeOrdinaryNative(text: input)
        XCTAssertEqual(output, expected)
        
        let decodedOutput = sut.decodeNative(tokens: output)
        XCTAssertEqual(decodedOutput, input)
    }
    
    func testEncodeOrdinaryNativeWithModel() async throws {
//        let input = "This is an example sentence to try encoding out on!"
//        let expected = [1212, 318, 281, 1672, 6827, 284, 1949, 21004, 503, 319, 0]
//        let input = "hello 👋 world 🌍"
//        let expected = [31373, 50169, 233, 995, 12520, 234, 235]
//
        let input = "Esto es un texto 👨🏻‍💻 con emojis diferentes 🍿💃🏼🧜‍♂️ y más texto que no tiene sentido 🛟"
        let expected = [22362, 78, 1658, 555, 2420, 78, 50169, 101, 8582, 237, 119, 447, 235, 8582, 240, 119, 369, 795, 13210, 271, 288, 361, 9100, 274, 12520, 235, 123, 8582, 240, 225, 8582, 237, 120, 8582, 100, 250, 447, 235, 17992, 224, 37929, 331, 285, 40138, 2420, 78, 8358, 645, 46668, 1734, 1908, 17305, 12520, 249, 253]


//        let input = "Vamos a probar🚒🚁🚀🚊 muchos emoticonos para probar⚽️🤸🏿‍♀️ diferentes codificaciones 👨🏻‍💻♨︎"
//        let expected = [53, 321, 418, 257, 1861, 283, 8582, 248, 240, 8582, 248, 223, 8582, 248, 222, 8582, 248, 232, 881, 418, 4085, 4749, 418, 31215, 1861, 283, 158, 248, 121, 37929, 8582, 97, 116, 8582, 237, 123, 447, 235, 17992, 222, 37929, 288, 361, 9100, 274, 14873, 811, 49443, 274, 50169, 101, 8582, 237, 119, 447, 235, 8582, 240, 119, 17992, 101, 35266, 236]
//
//        let encoderGPT = await Load.dataGymToMergeableBpeRanks(vocabBpeFile: "https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/vocab.bpe", encoderJsonFile: "")
        let encoder = await Load.loadTiktokenBpe(url: "https://openaipublic.blob.core.windows.net/encodings/r50k_base.tiktoken")
        
        
//        "pat_str": r"""'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+""",
//        let regex = try XCTUnwrap(try NSRegularExpression(pattern: "/'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+/gu"))
        let decoder = encoder.reduce(into: [:], { $0[$1.value] = $1.key })
//        r"""'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+""",
//        let regex = try XCTUnwrap(try NSRegularExpression(pattern: "/'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+/gu"))
        
//        r"""(?i:'s|'t|'re|'ve|'m|'ll|'d)|[^\r\n\p{L}\p{N}]?\p{L}+|\p{N}{1,3}| ?[^\s\p{L}\p{N}]+[\r\n]*|\s*[\r\n]+|\s+(?!\S)|\s+"""
        let regex = try XCTUnwrap(try NSRegularExpression(pattern: "/(?i:'s|'t|'re|'ve|'m|'ll|'d)|[^\\r\\n\\p{L}\\p{N}]?\\p{L}+|\\p{N}{1,3}| ?[^\\s\\p{L}\\p{N}]+[\\r\\n]*|\\s*[\\r\\n]+|\\s+(?!\\S)|\\s+/gu"))
        sut = .init(encoder: encoder, decoder: decoder, regexTls: [regex])
        
        let output = sut.encodeOrdinaryNative(text: input)
        XCTAssertEqual(output, expected)
        
        let decodedOutput = sut.decodeNative(tokens: output)
        XCTAssertEqual(decodedOutput, input)
    }
    
    func testGivenPromptWhenEncodedThenMatch() async throws {
        let input = "Esto es un texto 👨🏻‍💻 con emojis diferentes 🍿💃🏼🧜‍ y más texto que no tiene sentido 🛟"
        let expected = [14101, 78, 1560, 653, 33125, 62904, 101, 9468, 237, 119, 378, 235, 93273, 119, 390, 100166, 46418, 11410, 235, 123, 93273, 225, 9468, 237, 120, 9468, 100, 250, 378, 235, 379, 11158, 33125, 1744, 912, 24215, 65484, 11410, 249, 253]
//
//        let input = "hello 👋 world 🌍"
//        let expected = [15339, 62904, 233, 1917, 11410, 234, 235]
        
        let encoder = await Load.loadTiktokenBpe(url: "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken")
        let decoder = encoder.reduce(into: [:], { $0[$1.value] = $1.key })
        let regex = try XCTUnwrap(try NSRegularExpression(pattern: "/(?i:'s|'t|'re|'ve|'m|'ll|'d)|[^\\r\\n\\p{L}\\p{N}]?\\p{L}+|\\p{N}{1,3}| ?[^\\s\\p{L}\\p{N}]+[\\r\\n]*|\\s*[\\r\\n]+|\\s+(?!\\S)|\\s+/gu"))
        sut = .init(encoder: encoder, decoder: decoder, regexTls: [regex])
        
        let output = sut.encodeOrdinaryNative(text: input)
        XCTAssertEqual(output, expected)
        
        let decodedOutput = sut.decodeNative(tokens: output)
        XCTAssertEqual(decodedOutput, input)
    }
}
