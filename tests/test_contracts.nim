import
  std/[unittest, options],
  warpy

suite "Contracts":
  var api: Warpy
  setup:
    api = newWarpy()

  # The Forge region ID (Jita's region, always has contracts).
  const theForge: int32 = 10000002

  test "/contracts/public/{region_id}":
    let resp = api.getPublicContracts(theForge)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    let first = resp.body.get[0]
    assert first.contractId > 0
    assert first.issuerId > 0

  test "/contracts/public/{region_id} pagination":
    let resp = api.getPublicContracts(theForge)
    assert resp.code == 200
    assert resp.xpages >= 1
