# mb-hmac

HMAC (Hash-Based Message Authentication Code) for MoonBit — SHA-256 and SHA-512 variants.

## Reference standards

- **RFC 2104** — HMAC: Keyed-Hashing for Message Authentication
- **RFC 4231** — Identifiers and Test Vectors for HMAC-SHA-224/256/384/512

## API

| Function | Description |
|----------|-------------|
| `hmac_sha256(message, key)` | Compute HMAC-SHA256 (Array[UInt] input) |
| `hmac_sha256_bytes(message, key)` | Compute HMAC-SHA256 (Bytes input) |
| `hmac_sha256_string(message, key)` | Compute HMAC-SHA256 (String input) |
| `verify_hmac_sha256(message, key, mac)` | HMAC-SHA256 verification |
| `verify_hmac_sha256_bytes(message, key, mac)` | Verification with Bytes input |
| `hmac_sha512(message, key)` | Compute HMAC-SHA512 (Array[UInt] input) |
| `hmac_sha512_bytes(message, key)` | Compute HMAC-SHA512 (Bytes input) |
| `hmac_sha512_string(message, key)` | Compute HMAC-SHA512 (String input) |
| `verify_hmac_sha512(message, key, mac)` | HMAC-SHA512 verification |
| `verify_hmac_sha512_bytes(message, key, mac)` | Verification with Bytes input |

## Usage

The snippet below belongs inside a function in a package importing this module as `@hmac`.

```moonbit
// Import crypto/mb-hmac/src as @hmac in the caller's moon.pkg.
// Synthetic example key.
let mac = @hmac.hmac_sha256_string("hello world", "synthetic-demo-key")
println(mac.length())
```

## Tests

```bash
moon test crypto/mb-hmac/src
```

### Test Coverage

- HMAC-SHA256 computation
- HMAC-SHA512 computation
- MAC comparison correctness
- Key normalization
- Empty message handling
- Empty key handling
- RFC 4231 test vectors