public struct Tiktoken {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    public func getEncoding(_ name: String) -> Encoding? {
        nil
    }
    
    public func getEncoding(for model: String) -> Encoding? {
        nil
    }
}

public extension Tiktoken {
    struct Model {
        let name: String
        let explicitNVocab: Int?
        let pattern: String
        let mergeableRanks: [[UInt8]: Int]
        let specialTokens: [String: Int] // TODO: Map to [UInt8]
        
        init(name: String,
             explicitNVocab: Int? = nil,
             pattern: String,
             mergeableRanks: [[UInt8] : Int],
             specialTokens: [String : Int]) {
            self.name = name
            self.explicitNVocab = explicitNVocab
            self.pattern = pattern
            self.mergeableRanks = mergeableRanks
            self.specialTokens = specialTokens
        }
    }
}

public extension Tiktoken.Model {
//    static var gpt2: Self {
//        .init(name: <#T##String#>,
//              pattern: <#T##String#>,
//              mergeableRanks: <#T##[[UInt8] : Int]#>,
//              specialTokens: <#T##[String : Int]#>)
//    }
}
