import
  std/[unittest, options],
  warpy

suite "Character":
  var api: Warpy
  setup:
    api = newWarpy()

  # Use CCP Bartender (well-known dev character).
  const testCharacterId: int32 = 2112625428

  test "/characters/{character_id}":
    let resp = api.getCharacter(testCharacterId)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.name != ""
    assert resp.body.get.corporationId > 0

  test "/characters/affiliation":
    let resp = api.postCharacterAffiliation(@[testCharacterId])
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len == 1
    assert resp.body.get[0].characterId == testCharacterId
    assert resp.body.get[0].corporationId > 0

  test "/characters/{character_id}/corporationhistory":
    let resp = api.getCharacterCorporationHistory(testCharacterId)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    assert resp.body.get[0].corporationId > 0

  test "/characters/{character_id}/portrait":
    let resp = api.getCharacterPortrait(testCharacterId)
    assert resp.code == 200
    assert resp.body.isSome
