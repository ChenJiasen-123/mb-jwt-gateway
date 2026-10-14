# JWT and authentication middleware

Import `ChenJiasen-123/mb-jwt-gateway/crypto/mb-jwt/src` as `@jwt` and
`ChenJiasen-123/mb-jwt-gateway/gateway/src` as `@gateway`.

1. Obtain a securely managed key and a token from the application.
2. Create a context with `@gateway.new_stream_context(token)`.
3. Call `@gateway.execute_security_filter_with_policy` with current time and
   explicit expected issuer/audience.
4. Reject unless `context.is_allowed` is true. Then apply application-specific
   authorization to `user_sub` and `user_role`.

JWT `verify` checks signatures and returns payload JSON; claims validation is
separate unless using the middleware. `decode` and `decode_header` provide
unauthenticated data only. The legacy filter omits issuer/audience constraints.
Exact signatures are in generated `.mbti` files and the [JWT guide](../crypto/mb-jwt/README.md).
