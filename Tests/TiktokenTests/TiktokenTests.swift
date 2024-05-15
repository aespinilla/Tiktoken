import XCTest
@testable import Tiktoken

final class TiktokenTests: XCTestCase {
    private var sut: Tiktoken = .shared

    func testGivenGPT2WhenDecodeThenMatch() async throws {
//        let input = "Esto es un texto 👨🏻‍💻 con emojis diferentes 🍿💃🏼🧜‍♂️ y más texto que no tiene sentido 🛟"
//        let expected = [22362, 78, 1658, 555, 2420, 78, 50169, 101, 8582, 237, 119, 447, 235, 8582, 240, 119, 369, 795, 13210, 271, 288, 361, 9100, 274, 12520, 235, 123, 8582, 240, 225, 8582, 237, 120, 8582, 100, 250, 447, 235, 17992, 224, 37929, 331, 285, 40138, 2420, 78, 8358, 645, 46668, 1734, 1908, 17305, 12520, 249, 253]
        
        let input = "這個算法真的太棒了"
        let expected = [34460, 247, 161, 222, 233, 163, 106, 245, 37345, 243, 40367, 253, 21410, 13783, 103, 162, 96, 240, 12859, 228]
        
        let encoder = try await sut.getEncoding("gpt2")
        let output = try XCTUnwrap(encoder?.encode(value: input))
        XCTAssertEqual(output, expected)
    }
    
    func testGivenGPT4WhenDecodeThenMatch() async throws {
//        let input = "Esto es un texto 👨🏻‍💻 con emojis diferentes 🍿💃🏼🧜‍ y más texto que no tiene sentido 🛟"
//        let expected = [14101, 78, 1560, 653, 33125, 62904, 101, 9468, 237, 119, 378, 235, 93273, 119, 390, 100166, 46418, 11410, 235, 123, 93273, 225, 9468, 237, 120, 9468, 100, 250, 378, 235, 379, 11158, 33125, 1744, 912, 24215, 65484, 11410, 249, 253]
        
        let input = "這個算法真的太棒了"
        let expected = [11589, 247, 20022, 233, 70203, 25333, 89151, 9554, 8192, 103, 77062, 240, 35287]
        
        let encoder = try await sut.getEncoding("gpt-4")
        let output = try XCTUnwrap(encoder?.encode(value: input))
        XCTAssertEqual(output, expected)
    }

    func testGivenGPT4oEncodeAndDecode() async throws {
        let input = "hello world"
        let encoder = try await sut.getEncoding("gpt-4o")
        let output = try XCTUnwrap(encoder?.encode(value: input))
        XCTAssertEqual(encoder?.decode(value: output), input)
    }
}
