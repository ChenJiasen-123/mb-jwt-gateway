///|
/// Derive public key from private key (32 bytes -> 65 bytes uncompressed).
pub fn derive_public_key(
  private_key : Array[UInt32],
) -> Result[Array[UInt32], String] {
  if private_key.length() != 32 {
    return Err("Private key must be 32 bytes")
  }
  let d = sc_from_bytes(private_key)
  if !sc_is_valid(d) {
    return Err("Private key out of range")
  }
  let q = point_mul(d, point_generator())
  let q_affine = point_to_affine(q)
  if q_affine.infinity {
    return Err("Invalid private key")
  }
  let pub_key : Array[UInt32] = []
  pub_key.push(0x04U)
  for v in fe_to_bytes(q_affine.x) {
    pub_key.push(v)
  }
  for v in fe_to_bytes(q_affine.y) {
    pub_key.push(v)
  }
  Ok(pub_key)
}
