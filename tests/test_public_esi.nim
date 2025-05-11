# test Public ESI API endpoints
import std/[unittest, options], warpy, jsony


suite "Public ESI API":
  suite "Status":
    test "/status":
      let api = newWarpy()
      let resp = api.getStatus()
      assert resp.code == 200
      assert resp.body.isSome
      echo toJson(resp.body.get)

    test "/status with etag":
      # test that etags work
      let api = newWarpy()
      let resp1 = api.getStatus()
      assert resp1.code == 200
      assert resp1.body.isSome
      echo resp1.etag
      let resp2 = api.getStatus(resp1.etag)
      assert resp2.code == 304
      assert resp2.body.isNone

  suite "Universe":
    test "/universe/ancestries":
      let api = newWarpy()
      let resp = api.getAncestries()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

  suite "Meta":
    test "/verify":
      let api = newWarpy()
      let resp = api.ping()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get == "ok"
    
    test "/status.json":
      let api = newWarpy()
      let resp = api.statusJson()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

    test "/versions":
      let api = newWarpy()
      let resp = api.getVersions()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
      # sanity check that latest exists
      assert resp.body.get.find("latest") != -1
