import
  std/[unittest, options],
  warpy, jsony

suite "Status":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/status":
    let resp = api.getStatus()
    assert resp.code == 200
    assert resp.body.isSome
    echo toJson(resp.body.get)

  test "/status with etag":
    # This test verifies that etags work properly.
    let resp1 = api.getStatus()
    assert resp1.code == 200
    assert resp1.body.isSome
    echo resp1.etag
    let resp2 = api.getStatus(resp1.etag)
    assert resp2.code == 304 # Etag match should return 304.
    assert resp2.body.isNone # Body should be empty, no new data.

