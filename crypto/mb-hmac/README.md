# mb-hmac

HMAC (Hash-Based Message Authentication Code) for MoonBit — SHA-256 and SHA-512 variants.

## Status

Experimental implementation. Tests cover selected behavior and vectors; they do not establish production readiness or side-channel resistance.

## Reference standards

- **RFC 2104** — HMAC: Keyed-Hashing for Message Authentication
- **RFC 4231** — Identifiers and Test Vectors for HMAC-SHA-224/256/384/512

## Performance

No reproducible per-operation benchmark is published for this standalone project.

## Security Considerations

- **Key normalization**: Keys longer than the hash block size are hashed before padding.
- **Block-size padding**: Automatic key padding per RFC 2104
- **Key handling**: Callers supply and protect keys; memory erasure is not guaranteed.

## API

| Function | Description |
|----------|-------------|
| `hmac_sha256(message, key)` | Compute HMAC-SHA256 (Array[UInt] input) |
| `hmac_sha256_bytes(message, key)` | Compute HMAC-SHA256 (Bytes input) |
| `hmac_sha256_string(message, key)` | Compute HMAC-SHA256 (String input) |
| `verify_hmac_sha256(message, key, mac)` | HMAC-SHA256 verification; runtime timing unverified |
| `verify_hmac_sha256_bytes(message, key, mac)` | Verification with Bytes input; runtime timing unverified |
| `hmac_sha512(message, key)` | Compute HMAC-SHA512 (Array[UInt] input) |
| `hmac_sha512_bytes(message, key)` | Compute HMAC-SHA512 (Bytes input) |
| `hmac_sha512_string(message, key)` | Compute HMAC-SHA512 (String input) |
| `verify_hmac_sha512(message, key, mac)` | HMAC-SHA512 verification; runtime timing unverified |
| `verify_hmac_sha512_bytes(message, key, mac)` | Verification with Bytes input; runtime timing unverified |

## Usage

The snippet below belongs inside a function in a package importing this module as `@hmac`.

```moonbit
// Import crypto/mb-hmac/src as @hmac in the caller's moon.pkg.
// This is a synthetic example key, not a key-generation or storage strategy.
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
- MAC comparison correctness; no timing proof
- Key normalization
- Empty message handling
- Empty key handling
- RFC 4231 test vectors