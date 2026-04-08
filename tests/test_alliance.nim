import
  std/[unittest, options],
  warpy

suite "Alliance":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/alliances":
    let resp = api.getAlliances()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/alliances/{alliance_id}":
    # First get the list, then fetch details for the first one.
    let listResp = api.getAlliances()
    assert listResp.body.isSome
    let allianceId = listResp.body.get[0]
    let resp = api.getAlliance(allianceId)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.name != ""
    assert resp.body.get.ticker != ""

  test "/alliances/{alliance_id}/corporations":
    let listResp = api.getAlliances()
    assert listResp.body.isSome
    let allianceId = listResp.body.get[0]
    let resp = api.getAllianceCorporations(allianceId)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/alliances/{alliance_id}/icons":
    let listResp = api.getAlliances()
    assert listResp.body.isSome
    let allianceId = listResp.body.get[0]
    let resp = api.getAllianceIcons(allianceId)
    assert resp.code == 200
    assert resp.body.isSome
