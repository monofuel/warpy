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
      # this test verifies that etags work properly
      let api = newWarpy()
      let resp1 = api.getStatus()
      assert resp1.code == 200
      assert resp1.body.isSome
      echo resp1.etag
      let resp2 = api.getStatus(resp1.etag)
      assert resp2.code == 304 # etag match should return 304
      assert resp2.body.isNone # body should be empty, no new data

  suite "Universe":
    test "/universe/ancestries":
      let api = newWarpy()
      # TODO test languages
      let resp = api.getAncestries()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
    
    test "/universe/asteroid_belts":
      let api = newWarpy()
      const asteroidBeltId = 40089226 # Belt in the Nonni system
      let resp = api.getAsteroidBelts(asteroidBeltId)
      assert resp.code == 200
      assert resp.body.isSome
      assert toJson(resp.body.get) == """{"name":"Nonni II - Asteroid Belt 1","position":{"x":-65319198720.0,"y":9657507840.0,"z":155492229120.0},"systemId":30001401}"""
    
    test "/universe/bloodlines":
      let api = newWarpy()
      let resp = api.getBloodlines()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
    
    test "/universe/categories":
      let api = newWarpy()
      let resp = api.getItemCategories()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

    test "/universe/categories/16":
      let api = newWarpy()
      let resp = api.getItemCategory(16)
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.categoryId == 16
      assert resp.body.get.name == "Skill"
      assert resp.body.get.published == true
      assert resp.body.get.groups.len > 0

    test "/universe/constellations":
      let api = newWarpy()
      let resp = api.getConstellations()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
      
    test "/universe/constellations/20000205":
      let api = newWarpy()
      let resp = api.getConstellation(20000205)
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.constellationId == 20000205
      assert resp.body.get.name == "Minnen"

    test "/universe/factions":
      let api = newWarpy()
      let resp = api.getFactions()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

    test "/universe/graphics":
      let api = newWarpy()
      let resp = api.getGraphics()  
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

    test "/universe/graphics/42":
      let api = newWarpy()
      let resp = api.getGraphic(42) # caracal
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.graphicId == 42
      assert resp.body.get.sofHullName == "cc3_t1"

    test "/universe/groups":
      let api = newWarpy()
      let resp = api.getGroups()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

    test "/universe/groups/26":
      let api = newWarpy()
      let resp = api.getGroup(26)
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.groupId == 26
      assert resp.body.get.name == "Cruiser"

    test "/universe/ids":
      let api = newWarpy()
      let resp = api.bulkNamesToIds(@["Caracal", "Muninn"])
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.inventoryTypes.len == 2
      assert resp.body.get.inventoryTypes[0].id == 621
      assert resp.body.get.inventoryTypes[0].name == "Caracal"
      assert resp.body.get.inventoryTypes[1].id == 12015
      assert resp.body.get.inventoryTypes[1].name == "Muninn"

#       {
#   "characters": [
#     {
#       "id": 95261047,
#       "name": "Caracal"
#     },
#     {
#       "id": 219948150,
#       "name": "Muninn"
#     }
#   ],
#   "inventory_types": [
#     {
#       "id": 621,
#       "name": "Caracal"
#     },
#     {
#       "id": 12015,
#       "name": "Muninn"
#     }
#   ]
# }
      

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
