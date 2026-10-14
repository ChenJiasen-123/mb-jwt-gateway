///|
test "security_filter_rejects_bad_token" {
  let ctx = new_stream_context("bad.token.here")
  let key = @mb_jwt.JwtKey::HS256("secret")
  execute_security_filter(ctx, key, 1000L)
  assert_false(ctx.is_allowed)
  assert_true(ctx.error_message != "")
}

///|
test "security_filter_rejects_malformed" {
  let ctx = new_stream_context("not-a-jwt")
  let key = @mb_jwt.JwtKey::HS256("secret")
  execute_security_filter(ctx, key, 1000L)
  assert_false(ctx.is_allowed)
}

///|
test "gateway_claims_parse_valid" {
  let json = "{\"sub\":\"user1\",\"exp\":2000000000}"
  let result = parse_gateway_claims(json)
  assert_true(
    match result {
      Ok(claims) => claims.sub == "user1"
      _ => false
    },
  )
}

///|
test "gateway_claims_parse_invalid" {
  let result = parse_gateway_claims("invalid json")
  assert_true(
    match result {
      Err(_) => true
      _ => false
    },
  )
}

///|
test "gateway_claims_parse_missing_sub" {
  let result = parse_gateway_claims("{\"exp\":2000000000}")
  assert_true(
    match result {
      Err(msg) => msg.contains("sub")
      _ => false
    },
  )
}

///|
test "gateway_claims_parse_non_object_json" {
  let result = parse_gateway_claims("\"string\"")
  assert_true(
    match result {
      Err(msg) => msg.contains("object")
      _ => false
    },
  )
}

///|
test "gateway_claims_parse_missing_exp" {
  let result = parse_gateway_claims("{\"sub\":\"user1\",\"iss\":\"issuer\"}")
  assert_true(
    match result {
      Err(msg) => msg.contains("exp")
      _ => false
    },
  )
}

///|
test "gateway_claims_parse_all_optional_fields" {
  let json = "{\"sub\":\"user1\",\"exp\":2000000000,\"nbf\":1000000000,\"iss\":\"my-issuer\",\"role\":\"admin\"}"
  let result = parse_gateway_claims(json)
  assert_true(
    match result {
      Ok(claims) => claims.sub == "user1" && claims.exp == 2000000000L
      _ => false
    },
  )
  assert_true(
    match result {
      Ok(claims) =>
        match claims.nbf {
          Some(n) => n == 1000000000L
          _ => false
        }
      _ => false
    },
  )
  assert_true(
    match result {
      Ok(claims) =>
        match claims.iss {
          Some(i) => i == "my-issuer"
          _ => false
        }
      _ => false
    },
  )
  assert_true(
    match result {
      Ok(claims) =>
        match claims.role {
          Some(r) => r == "admin"
          _ => false
        }
      _ => false
    },
  )
}

///|
test "gateway_claims_parse_optional_fields_none" {
  let json = "{\"sub\":\"user1\",\"exp\":2000000000}"
  let result = parse_gateway_claims(json)
  assert_true(
    match result {
      Ok(claims) => claims.sub == "user1"
      _ => false
    },
  )
  assert_true(
    match result {
      Ok(claims) =>
        match claims.nbf {
          None => true
          _ => false
        }
      _ => false
    },
  )
  assert_true(
    match result {
      Ok(claims) =>
        match claims.iss {
          None => true
          _ => false
        }
      _ => false
    },
  )
  assert_true(
    match result {
      Ok(claims) =>
        match claims.role {
          None => true
          _ => false
        }
      _ => false
    },
  )
}

///|
test "security_filter_valid_token" {
  // Create a valid signed JWT and verify it passes
  let payload = "{\"sub\":\"user1\",\"role\":\"admin\",\"exp\":2000000000}"
  let key = @mb_jwt.JwtKey::HS256("secret")
  let token = match @mb_jwt.sign(payload, key) {
    Ok(t) => t
    Err(_) => {
      assert_true(false)
      return
    }
  }
  let ctx = new_stream_context(token)
  execute_security_filter(ctx, key, 1000000L)
  assert_true(ctx.is_allowed)
  assert_eq(ctx.user_sub, "user1")
  assert_eq(ctx.user_role, "admin")
}

///|
test "security_filter_expired_token" {
  let payload = "{\"sub\":\"user1\",\"exp\":1000}"
  let key = @mb_jwt.JwtKey::HS256("secret")
  let token = match @mb_jwt.sign(payload, key) {
    Ok(t) => t
    Err(_) => {
      assert_true(false)
      return
    }
  }
  let ctx = new_stream_context(token)
  execute_security_filter(ctx, key, 2000L)
  assert_false(ctx.is_allowed)
  assert_true(ctx.error_message.contains("expired"))
}

///|
test "security_filter_nbf_token" {
  let payload = "{\"sub\":\"user1\",\"nbf\":5000,\"exp\":10000}"
  let key = @mb_jwt.JwtKey::HS256("secret")
  let token = match @mb_jwt.sign(payload, key) {
    Ok(t) => t
    Err(_) => {
      assert_true(false)
      return
    }
  }
  let ctx = new_stream_context(token)
  execute_security_filter(ctx, key, 1000L) // before nbf
  assert_false(ctx.is_allowed)
  assert_true(ctx.error_message.contains("nbf"))
}

///|
test "security_filter_guest_role" {
  let payload = "{\"sub\":\"guest-user\",\"exp\":2000000000}"
  let key = @mb_jwt.JwtKey::HS256("secret")
  let token = match @mb_jwt.sign(payload, key) {
    Ok(t) => t
    Err(_) => {
      assert_true(false)
      return
    }
  }
  let ctx = new_stream_context(token)
  execute_security_filter(ctx, key, 1000000L)
  assert_true(ctx.is_allowed)
  assert_eq(ctx.user_role, "guest")
}
