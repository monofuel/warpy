import
  std/[unittest, options],
  warpy

suite "Insurance":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/insurance/prices":
    let resp = api.getInsurancePrices()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # Spot check first entry.
    let first = resp.body.get[0]
    assert first.typeId > 0
    assert first.levels.len > 0
