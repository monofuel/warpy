import
  std/[unittest, options],
  warpy

suite "Faction Warfare":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/fw/stats":
    let resp = api.getFwStats()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    let first = resp.body.get[0]
    assert first.factionId > 0

  test "/fw/leaderboards":
    let resp = api.getFwLeaderboards()
    assert resp.code == 200
    assert resp.body.isSome

  test "/fw/leaderboards/characters":
    let resp = api.getFwCharacterLeaderboards()
    assert resp.code == 200
    assert resp.body.isSome

  test "/fw/leaderboards/corporations":
    let resp = api.getFwCorporationLeaderboards()
    assert resp.code == 200
    assert resp.body.isSome

  test "/fw/systems":
    let resp = api.getFwSystems()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    let first = resp.body.get[0]
    assert first.solarSystemId > 0

  test "/fw/wars":
    let resp = api.getFwWars()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
