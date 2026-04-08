import
  std/[unittest, options],
  warpy

suite "Corporation":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/corporations/npccorps":
    let resp = api.getNpcCorps()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/corporations/{corporation_id}":
    # Use first NPC corp for a stable test target.
    let npcResp = api.getNpcCorps()
    assert npcResp.body.isSome
    let corpId = npcResp.body.get[0]
    let resp = api.getCorporation(corpId)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.name != ""
    assert resp.body.get.ticker != ""

  test "/corporations/{corporation_id}/alliancehistory":
    let npcResp = api.getNpcCorps()
    assert npcResp.body.isSome
    let corpId = npcResp.body.get[0]
    let resp = api.getCorporationAllianceHistory(corpId)
    assert resp.code == 200
    assert resp.body.isSome
    # NPC corps may not have alliance history, but response should be valid.
    assert resp.body.get.len >= 0

  test "/corporations/{corporation_id}/icons":
    let npcResp = api.getNpcCorps()
    assert npcResp.body.isSome
    let corpId = npcResp.body.get[0]
    let resp = api.getCorporationIcons(corpId)
    assert resp.code == 200
    assert resp.body.isSome
