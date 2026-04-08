import
  std/[unittest, options],
  warpy

suite "Dogma":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/dogma/attributes":
    let resp = api.getDogmaAttributes()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/dogma/attributes/{attribute_id}":
    let listResp = api.getDogmaAttributes()
    assert listResp.body.isSome
    let attrId = listResp.body.get[0]
    let resp = api.getDogmaAttribute(attrId)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.attributeId == attrId

  test "/dogma/effects":
    let resp = api.getDogmaEffects()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/dogma/effects/{effect_id}":
    let listResp = api.getDogmaEffects()
    assert listResp.body.isSome
    let effectId = listResp.body.get[0]
    let resp = api.getDogmaEffect(effectId)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.effectId == effectId
