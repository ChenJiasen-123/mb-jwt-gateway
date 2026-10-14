# mb-p256

ECDSA P-256 (secp256r1) public-key signatures for MoonBit.

## Reference standards

- **RFC 7518** — JSON Web Algorithms (JWA) — ES256
- **FIPS 186-4** — Digital Signature Standard (DSS)
- **SEC 1** — Elliptic Curve Cryptography

## API

- `derive_public_key(private_key)` derives a public key.
- `ecdsa_keygen(private_key)` and `ecdsa_keygen_bytes(private_key)` derive a key pair from caller-supplied private key material; they do not generate random keys.
- `ecdsa_sign_message(private_key, message)` and `ecdsa_verify_message(public_key, message, signature)` operate on messages.
- `ecdsa_sign` / `ecdsa_verify` operate on hashes; consult `src/pkg.generated.mbti` for exact types and Bytes variants.

Handle Result errors and source private keys from a secure random generator.

## Tests

```bash
moon test crypto/mb-p256/src
```

### Test Coverage

- Key generation
- Sign/verify roundtrip
- Public key derivation
- Wrong public key rejection
- Tampered message rejection
- Wrong signature rejection
- RFC 6979 deterministic k
- NIST test vectors