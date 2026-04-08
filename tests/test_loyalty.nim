import
  std/[unittest, options],
  warpy

suite "Loyalty":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/loyalty/stores/{corporation_id}/offers":
    # Use an NPC corp that has LP offers.
    let npcResp = api.getNpcCorps()
    assert npcResp.body.isSome
    assert npcResp.body.get.len > 0
    # Try a few NPC corps until we find one with offers.
    var found = false
    for corpId in npcResp.body.get:
      try:
        let resp = api.getLoyaltyOffers(corpId)
        if resp.code == 200 and resp.body.isSome and resp.body.get.len > 0:
          let first = resp.body.get[0]
          assert first.offerId > 0
          assert first.typeId > 0
          found = true
          break
      except WarpyError:
        continue
    assert found, "Could not find an NPC corp with loyalty offers"
