import
  std/[unittest, options],
  warpy

suite "Industry":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/industry/facilities":
    let resp = api.getIndustryFacilities()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    let first = resp.body.get[0]
    assert first.facilityId > 0
    assert first.solarSystemId > 0

  test "/industry/systems":
    let resp = api.getIndustrySystems()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    let first = resp.body.get[0]
    assert first.solarSystemId > 0
    assert first.costIndices.len > 0
