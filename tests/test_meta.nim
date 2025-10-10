import
  std/[unittest, options, tables],
  warpy

suite "Meta":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/verify":
    let resp = api.ping()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get == "ok"

  test "/status.json":
    let resp = api.statusJson()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/versions":
    let resp = api.getVersions()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # Sanity check that latest exists.
    assert resp.body.get.find("latest") != -1

  test "/meta/changelog":
    let resp = api.getChangelog()
    assert resp.code == 200
    assert resp.body.isSome
    # Changelog is a table, verify it has entries.
    var hasEntries = false
    for key, value in resp.body.get.changelog:
      hasEntries = true
      break
    assert hasEntries

  test "/meta/compatibility-dates":
    let resp = api.getCompatibilityDates()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.compatibilityDates.len > 0

