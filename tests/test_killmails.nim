import
  std/[unittest, options],
  warpy

suite "Killmails":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/killmails/{killmail_id}/{killmail_hash}":
    # Get a killmail from war killmails (already implemented).
    let warsResp = api.getWars()
    assert warsResp.body.isSome
    assert warsResp.body.get.len > 0
    # Try to find a war with killmails.
    var found = false
    for warId in warsResp.body.get:
      let kmResp = api.getWarKillmails(warId)
      if kmResp.body.isSome and kmResp.body.get.len > 0:
        let km = kmResp.body.get[0]
        let resp = api.getKillmail(km.killmailId, km.killmailHash)
        assert resp.code == 200
        assert resp.body.isSome
        assert resp.body.get.killmailId == km.killmailId
        assert resp.body.get.solarSystemId > 0
        assert resp.body.get.attackers.len > 0
        found = true
        break
    assert found, "Could not find a war with killmails to test"
