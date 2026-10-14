# mb-jwt-gateway

Experimental MoonBit JWT signing/verification and gateway policy components,
extracted from mb-secure-stream so stream encryption and gateway concerns can
evolve independently. This project is unaudited and does not guarantee
constant-time execution or production readiness.

## Components

- [JWT](crypto/mb-jwt/README.md): HS256/ES256 and claims validation.
- [Gateway](gateway/README.md): JWT policy, rate limiting, circuit breaking,
  replay protection, scheduling, bandwidth and request metrics.
- [Worker](examples/cloudflare-worker/README.md): independent TypeScript/Web
  Crypto implementation. It does not invoke the MoonBit gateway or JWT library.
- Supporting SHA-2, HMAC and P-256 modules; no secretstream implementation.

These are library components and an example, not a hosted gateway service.
No Cloudflare deployment is performed by project builds or CI.

## Build and verify

Requires MoonBit (tested 0.10.15) and Node 24. From this repository:

```sh
moon check --deny-warn
moon test
moon test --target js
moon info
moon fmt --check gateway/src crypto/mb-jwt/src crypto/mb-p256/src crypto/mb-hmac/src crypto/mb-hash/src/sha2
cd examples/cloudflare-worker
npm ci --ignore-scripts
npm test
npm run check
npm run build
```

Linux CI additionally tests the Native backend. Windows Native requires MSVC
and the Windows SDK. `npm run build` only bundles with `wrangler deploy --dry-run`.
Configure actual issuer/audience/origin policy and secret storage before any
intentional deployment; see the Worker README.

## Migration from mb-secure-stream

For source consumers, change the module dependency to
`ChenJiasen-123/mb-jwt-gateway` and replace that prefix in JWT/gateway package
imports. Package suffixes such as `/gateway/src` and `/crypto/mb-jwt/src` are
retained. Source migration does not imply a Mooncakes release exists; use the
GitHub source release until a registry version is explicitly announced.

Previously published mb-secure-stream 0.2.0 remains immutable and continues to
provide its historical packages. No existing release is overwritten.
See [API notes](docs/gateway-api.md) and generated package interfaces for signatures.

## Provenance and license

Apache-2.0. [NOTICE](NOTICE) and [source manifest](docs/extraction.json) record
the exact originating commit and pre-extraction file hashes. Supporting crypto
modules derive from moonbit-crypto/mb-crypto; gateway/JWT extensions and Worker
come from mb-secure-stream. Extraction does not make them newly invented work.
