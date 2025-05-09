# test Public ESI API endpoints
import std/[unittest], warpy, jsony


suite "Public ESI API":
  test "get status":
    let api = newWarpy()
    let status = api.getStatus()
    echo toJson(status)
