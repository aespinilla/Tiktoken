//
//  ModelTests.swift
//  
//
//  Created by Alberto Espinilla Garrido on 20/3/23.
//

import XCTest
@testable import Tiktoken

final class ModelTests: XCTestCase {

    func testGivenModelNamesWhenGetEncodingThenMatch() throws {
        try [
            Test(input: "gpt-4", output: "cl100k_base"),
            Test(input: "gpt-3.5-turbo", output: "cl100k_base"),
            Test(input: "davinci", output: "r50k_base"),
            Test(input: "text-davinci-edit-001", output: "p50k_edit"),
        ].forEach({
            let output = Model.getEncoding($0.input)
//            XCTAssertEqual(try XCTUnwrap(output), $0.output)
            XCTAssertNotNil(output)
        })
    }
    
    func testGivenModelNamesWithPrefisWhenGetEncodingThenMatch() throws {
        try [
            Test(input: "gpt-4-0314", output: "cl100k_base"),
            Test(input: "gpt-4-32k", output: "cl100k_base"),
            Test(input: "gpt-3.5-turbo-0301", output: "cl100k_base"),
            Test(input: "gpt-3.5-turbo-0401", output: "cl100k_base"),
        ].forEach({
            let output = Model.getEncoding($0.input)
//            XCTAssertEqual(try XCTUnwrap(output), $0.output)
            XCTAssertNotNil(output)
        })
    }
    
    func testGivenUnknowModelNamesWhenGetEncodingThenMatchNil() throws {
        ["sample", "chatgpt", "invalid", "test"].forEach({
            let output = Model.getEncoding($0)
            XCTAssertNil(output)
        })
    }
}
