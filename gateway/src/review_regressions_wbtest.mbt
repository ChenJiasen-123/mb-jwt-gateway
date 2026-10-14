///|
test "gateway policy rejects missing and mismatched issuer and audience" {
  let key = @mb_jwt.JwtKey::HS256("synthetic-regression-key")
  let good = "{\"sub\":\"u\",\"exp\":10000,\"iss\":\"issuer\",\"aud\":\"service\"}"
  let ctx = new_stream_context(@mb_jwt.sign(good, key).unwrap())
  execute_security_filter_with_policy(
    ctx,
    key,
    1000L,
    Some("issuer"),
    Some("service"),
  )
  assert_true(ctx.is_allowed)
  execute_security_filter_with_policy(
    ctx,
    key,
    1000L,
    Some("other"),
    Some("service"),
  )
  assert_false(ctx.is_allowed)
  assert_eq(ctx.user_sub, "")
  execute_security_filter_with_policy(
    ctx,
    key,
    1000L,
    Some("issuer"),
    Some("other"),
  )
  assert_false(ctx.is_allowed)
  for
    payload in [
      "{\"sub\":\"u\",\"exp\":10000,\"aud\":\"service\"}", "{\"sub\":\"u\",\"exp\":10000,\"iss\":\"issuer\"}",
    ] {
    let missing = new_stream_context(@mb_jwt.sign(payload, key).unwrap())
    execute_security_filter_with_policy(
      missing,
      key,
      1000L,
      Some("issuer"),
      Some("service"),
    )
    assert_false(missing.is_allowed)
  }
  // Legacy entry point deliberately keeps optional issuer/audience policy.
  execute_security_filter(ctx, key, 1000L)
  assert_true(ctx.is_allowed)
}

///|
test "gateway claim parsing rejects malformed optional claims and inexact dates" {
  for
    value in [
      "\"2000\"", "null", "[]", "{}", "true", "1.5", "9007199254740992", "1e100",
    ] {
    let payload = "{\"sub\":\"u\",\"exp\":10000,\"nbf\":" + value + "}"
    assert_true(parse_gateway_claims(payload) is Err(_))
  }
  for field in ["iss", "aud", "role"] {
    for value in ["null", "[]", "{}", "true", "1"] {
      let payload = "{\"sub\":\"u\",\"exp\":10000,\"" +
        field +
        "\":" +
        value +
        "}"
      assert_true(parse_gateway_claims(payload) is Err(_))
    }
  }
  for value in ["1.5", "9007199254740992", "1e100"] {
    assert_true(
      parse_gateway_claims("{\"sub\":\"u\",\"exp\":" + value + "}") is Err(_),
    )
  }
  let key = @mb_jwt.JwtKey::HS256("synthetic-regression-key")
  let token = @mb_jwt.sign(
    "{\"sub\":\"u\",\"exp\":10000,\"nbf\":\"9000\"}", key,
  ).unwrap()
  let ctx = new_stream_context(token)
  execute_security_filter(ctx, key, 1000L)
  assert_false(ctx.is_allowed)
  assert_true(
    parse_gateway_claims("{\"sub\":\"u\",\"exp\":9007199254740991,\"nbf\":-1}")
    is Ok(_),
  )
}
