# mb-hash

SHA-2 family hash functions for MoonBit — SHA-256 and SHA-512.

## Reference standards

- **RFC 6234** — SHA-2 Hash Functions
- **FIPS 180-4** — Secure Hash Standard (SHS)

## API

| Function | Description |
|----------|-------------|
| `Sha256::new()` | Create a new SHA-256 hasher |
| `Sha256::update(input)` | Feed data (streaming) |
| `Sha256::finalize()` | Produce SHA-256 hash |
| `Sha256::digest(input)` | One-shot SHA-256 (Array[UInt]) |
| `Sha256::digest_bytes(input)` | One-shot SHA-256 (Bytes) |
| `Sha256::digest_string(input)` | One-shot SHA-256 (String) |
| `Sha512::new()` | Create a new SHA-512 hasher |
| `Sha512::update(input)` | Feed data (streaming) |
| `Sha512::finalize()` | Produce SHA-512 hash |
| `Sha512::digest(input)` | One-shot SHA-512 (Array[UInt]) |
| `Sha512::digest_bytes(input)` | One-shot SHA-512 (Bytes) |
| `Sha512::digest_string(input)` | One-shot SHA-512 (String) |
| `hash_to_hex(hash)` | Convert hash to hex string |

## Usage

```moonbit
let hash = Sha256::digest_string("hello world")
println(hash_to_hex(hash))
```

## Tests

```bash
moon test crypto/mb-hash/src/sha2
```

### Test Coverage

- SHA-256 known test vectors (NIST)
- SHA-512 known test vectors (NIST)
- Streaming vs one-shot consistency
- Empty input handling
- Large input handling (multi-block)
- Hex encoding/decoding