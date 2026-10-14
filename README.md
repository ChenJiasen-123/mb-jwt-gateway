# mb-jwt-gateway

[Source prerelease v0.1.0](https://github.com/ChenJiasen-123/mb-jwt-gateway/releases/tag/v0.1.0) · [CI](https://github.com/ChenJiasen-123/mb-jwt-gateway/actions)

Experimental MoonBit JWT signing/verification and authentication middleware.
The project has one purpose: verify an HS256/ES256 token, validate time and
issuer/audience policy, and expose the authenticated identity to a caller.
It provides reusable library packages.

## Scope

- [JWT](crypto/mb-jwt/README.md): HS256/ES256 signing, verification and claims.
- [Authentication middleware](gateway/README.md): subject, role, expiry,
  not-before and explicit issuer/audience policy; clears identity on failure.
- Supporting SHA-2, HMAC and P-256 ECDSA implementation, with original provenance.

## Build and verify

Tested with MoonBit 0.10.15. From this repository:

```sh
moon check --deny-warn
moon test
moon test --target js
moon info
moon fmt --check gateway/src crypto/mb-jwt/src crypto/mb-p256/src crypto/mb-hmac/src crypto/mb-hash/src/sha2
```

Linux CI also tests Native. Windows Native needs MSVC and the Windows SDK.
No Node/npm dependency, external API account or cloud deployment is needed.
Use explicit issuer/audience policy when the same key is shared by services.
See [usage](docs/gateway-api.md) and generated interfaces for exact signatures.

## Migration

Extracted from [mb-secure-stream](https://github.com/ChenJiasen-123/mb-secure-stream).
Replace the module prefix `ChenJiasen-123/mb-secure-stream` with
`ChenJiasen-123/mb-jwt-gateway` for JWT and authentication middleware imports.
Suffixes `/crypto/mb-jwt/src` and `/gateway/src` remain the same.
The old flow-control and Worker features were intentionally not carried into
this focused project. They remain recoverable from the original repository's
[pre-split source history](https://github.com/ChenJiasen-123/mb-secure-stream/tree/bc8fa03c14d32534d4cb3412a6ff996314bf4f97).

Use this GitHub source release until a Mooncakes version is explicitly announced.
The original mb-secure-stream 0.2.0 release is unchanged.

## License and provenance

Apache-2.0. [NOTICE](NOTICE) and [extraction manifest](docs/extraction.json)
identify the exact originating commit and original file hashes. Supporting
crypto derives from moonbit-crypto/mb-crypto. Existing code is not presented
as newly invented work.
