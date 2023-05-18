//
//  FileDecoderTests.swift
//  
//
//  Created by Alberto Espinilla Garrido on 10/4/23.
//

import XCTest
@testable import Tiktoken

final class FileDecoderTests: XCTestCase {
    private var sut: FileDecoder!

    override func setUpWithError() throws {
        sut = FileDecoder()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testGivenInvalidDataWhenDecodeThenMatchEmptyDictionary() throws {
        let data = Data()
        let expected: [[UInt8]: Int] = [:]
        let output = sut.decode(data)
        XCTAssertEqual(output, expected)
    }
    
    func testGivenInvalidDataEncodedWhenDecodeThenMatchEmptyDictionary() throws {
        let test = """
        sample
        other sample
        fail
        """
        
        let expected: [[UInt8]: Int] = [:]
        let input = try XCTUnwrap(test.data(using: .utf8))
        let output = sut.decode(input)
        XCTAssertEqual(output, expected)
    }
    
    func testGivenDataWhenDecodeThenMatchDictionary() throws {
        let test = """
        Zm9v 10
        Zm9vMQ== 20
        cmFuZG9t 100
        """
        
        let expected: [[UInt8]: Int] = [
            [102, 111, 111]: 10,
            [102, 111, 111, 49]: 20,
            [114, 97, 110, 100, 111, 109]: 100
        ]
        
        let input = try XCTUnwrap(test.data(using: .utf8))
        let output = sut.decode(input)
        XCTAssertEqual(output, expected)
    }
}
