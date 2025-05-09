# test Public ESI API endpoints
import std/[unittest, options], warpy, jsony


suite "Public ESI API":
  test "get status":
    let api = newWarpy()
    let resp = api.getStatus()
    assert resp.code == 200
    assert resp.body.isSome
    echo toJson(resp.body.get)

  test "get status with etag":
    let api = newWarpy()
    let resp1 = api.getStatus()
    assert resp1.code == 200
    assert resp1.body.isSome
    echo resp1.etag
    let resp2 = api.getStatus(resp1.etag)
    assert resp2.code == 304
    assert resp2.body.isNone