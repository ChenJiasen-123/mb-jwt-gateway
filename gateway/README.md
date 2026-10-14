# JWT authentication middleware

The middleware verifies a JWT and validates gateway identity claims. It has no
HTTP server or transport binding. Applications supply the token, key and time.

Use `new_stream_context(token)`, then
`execute_security_filter_with_policy(context, key, time, expected_issuer, expected_audience)`.
After the call, check `is_allowed` before reading `user_sub` or `user_role`.
Each invocation clears previous identity and error state before validation.
A missing role defaults to `guest`; it is not an authorization decision.

The compatibility entry point `execute_security_filter` does not constrain
issuer or audience. Prefer the policy entry point for shared keys.
`parse_gateway_claims` parses data; it does not authenticate a token.

See [usage](../docs/gateway-api.md) and `src/pkg.generated.mbti` for types.
JWT verification is experimental and unaudited. There is no replay cache,
revocation, rate limiting, HTTP forwarding or guaranteed constant-time execution.
