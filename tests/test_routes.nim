import
  std/[unittest, options],
  warpy

suite "Routes":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/route/{origin}/{destination}":
    # Route from Jita (30000142) to Amarr (30002187).
    let resp = api.getRoute(origin = 30000142, destination = 30002187)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # First system should be origin, last should be destination.
    assert resp.body.get[0] == 30000142
    assert resp.body.get[^1] == 30002187

  test "/route with avoid":
    # Route from Jita to Amarr, avoiding Niarja (30002659).
    let resp = api.getRoute(
      origin = 30000142,
      destination = 30002187,
      avoid = @[30002659.int32]
    )
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # Niarja should not be in the route.
    assert 30002659.int32 notin resp.body.get

  test "/route with flag":
    # Secure route.
    let resp = api.getRoute(
      origin = 30000142,
      destination = 30002187,
      flag = secure
    )
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

