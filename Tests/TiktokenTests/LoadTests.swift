//
//  LoadTests.swift
//  
//
//  Created by Alberto Espinilla Garrido on 22/3/23.
//

import XCTest
@testable import Tiktoken

final class LoadTests: XCTestCase {
    func testExample() async throws {
        let result = try? await Load.dataGymToMergeableBpeRanks(vocabBpeFile: "", encoderJsonFile: "")
        XCTAssertNotNil(result)
    }
    
    func testLoadBpe() async throws {
        let result = try? await Load.loadTiktokenBpe(url: "https://openaipublic.blob.core.windows.net/encodings/r50k_base.tiktoken")
        XCTAssertNotNil(result)
    }
}
