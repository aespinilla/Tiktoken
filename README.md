# Tiktoken

Openai's Tiktoken implementation written in Swift. This is basic implementation from ordinary encode/decode.

Supports vocab:
- gpt2 (Same for gpt3)
- r50k_base
- p50k_base
- p50k_edit
- cl100k_base (gpt-4 and gpt-3.5)

And also supports asian characters and emojis.

Stars are welcome 😊.

## Usage

```swift
let encoder = try await Tiktoken.shared.getEncoding("gpt-4")
let encoded = encoder?.encode(value: "這個算法真的太棒了")
print(encoded)
let decoded = encoder?.decode(value: encoded)
print(decoded)
```

## TODO List

- Encode native
- Encode unstable native
- Multithread
- Custom vocab
- Implements cache for loaded encoding
- Add/Improve documentation
- Add support for combine
- Optimization performance
- More testing
