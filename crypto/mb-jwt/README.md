# mb-jwt

JWT (JSON Web Tokens) for MoonBit — HS256 and ES256 signing/verification.

## Reference standards

- **RFC 7519** — JSON Web Tokens (JWT)
- **RFC 7515** — JSON Web Signature (JWS)
- **RFC 7518** — JSON Web Algorithms (JWA)

## API

| Function | Description |
|----------|-------------|
| `sign(payload, key)` | Create signed JWT (HS256 or ES256) |
| `verify(token, key)` | Verify signature and decode; validate claims separately |
| `decode(token)` | Decode without verification |
| `decode_header(token)` | Decode header without verification |
| `validate_claims(payload, current_time, expected_iss, expected_aud)` | Validate exp, nbf, iss, aud |
| `base64url_encode(data)` | Base64URL encode |
| `base64url_decode(encoded)` | Base64URL decode |

## Algorithms

- **HS256** — HMAC-SHA256 (symmetric)
- **ES256** — ECDSA P-256 + SHA-256 (asymmetric)

## Usage

Import `ChenJiasen-123/mb-jwt-gateway/crypto/mb-jwt/src` as `@mb_jwt` in the caller's `moon.pkg`. The snippet below belongs inside a function.

```moonbit
let key = @mb_jwt.JwtKey::HS256("your-secret")
let payload = "{\"sub\":\"user\",\"exp\":2000000000}"

let token = match @mb_jwt.sign(payload, key) {
  Ok(t) => t
  Err(_) => abort("sign failed")
}

match @mb_jwt.verify(token, key) {
  Ok(p) => println("Signature verified; claims still need validation: " + p)
  Err(e) => println("Invalid: \{e}")
}
```

## Tests

```bash
moon test crypto/mb-jwt/src
```

### Test Coverage

- JWT sign/verify roundtrip (HS256, ES256)
- Invalid signature detection
- Malformed token handling
- alg:none attack rejection (CVE-2016-5431)
- Algorithm confusion prevention
- Signature strip attack detection
- Truncated token rejection
- Payload tampering detection
- Header injection prevention
- Empty or invalid key handling
- Cross-token signature reuse prevention
- Expired token rejection
- Not-before (nbf) enforcement
- Issuer validation
- Audience validation
- Empty key handling
- Base64url padding confusion
- ES256 all-zero signature rejection
- ES256 truncated signature rejection