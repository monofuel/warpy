import
  std/[unittest, options],
  warpy

suite "Sovereignty":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/sovereignty/campaigns":
    let resp = api.getSovereigntyCampaigns()
    assert resp.code == 200
    assert resp.body.isSome
    # May not always have active campaigns, but response should be valid.
    assert resp.body.get.len >= 0

  test "/sovereignty/map":
    let resp = api.getSovereigntyMap()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # Check that systems have IDs.
    for system in resp.body.get:
      assert system.systemId > 0

  test "/sovereignty/structures":
    let resp = api.getSovereigntyStructures()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # Check that structures have required fields.
    for structure in resp.body.get:
      assert structure.structureId > 0
      assert structure.allianceId > 0
      assert structure.solarSystemId > 0
      assert structure.structureTypeId > 0

