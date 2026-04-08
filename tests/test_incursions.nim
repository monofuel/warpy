import
  std/[unittest, options],
  warpy

suite "Incursions":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/incursions":
    let resp = api.getIncursions()
    assert resp.code == 200
    assert resp.body.isSome
    # May not always have active incursions.
    assert resp.body.get.len >= 0
