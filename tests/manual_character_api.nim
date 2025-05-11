# Manual test for character API
# requires that you oauth with a character

import std/[unittest, options], warpy, jsony


suite "Public ESI API":
  setup:
    let api = newWarpy()
    # TODO oauth login

  test "get status":
    let resp = api.getStatus()
    assert resp.code == 200
    assert resp.body.isSome
    echo toJson(resp.body.get)
