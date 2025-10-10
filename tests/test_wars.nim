import
  std/[unittest, options],
  warpy

suite "Wars":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/wars":
    let resp = api.getWars()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/wars with max_war_id":
    let resp = api.getWars(maxWarId = 500000)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # All returned war IDs should be less than or equal to max_war_id.
    for warId in resp.body.get:
      assert warId <= 500000

  test "/wars/{war_id}":
    # Get a recent war ID first.
    let warsResp = api.getWars()
    assert warsResp.code == 200
    assert warsResp.body.isSome
    assert warsResp.body.get.len > 0

    let warId = warsResp.body.get[0]
    let resp = api.getWar(warId)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.id == warId
    assert resp.body.get.declared != ""
    assert resp.body.get.aggressor != nil
    assert resp.body.get.defender != nil

  test "/wars/{war_id}/killmails":
    # Get a recent war ID first.
    let warsResp = api.getWars()
    assert warsResp.code == 200
    assert warsResp.body.isSome
    assert warsResp.body.get.len > 0

    let warId = warsResp.body.get[0]
    let resp = api.getWarKillmails(warId)
    assert resp.code == 200
    assert resp.body.isSome
    # May not have killmails, but the response should be valid.
    assert resp.body.get.len >= 0

