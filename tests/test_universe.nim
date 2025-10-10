import
  std/[unittest, options, strformat, os],
  warpy, jsony

suite "Universe":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/universe/ancestries":
    # TODO test languages.
    let resp = api.getAncestries()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/asteroid_belts":
    const asteroidBeltId = 40089226 # Belt in the Nonni system.
    let resp = api.getAsteroidBelts(asteroidBeltId)
    assert resp.code == 200
    assert resp.body.isSome
    assert toJson(resp.body.get) == """{"name":"Nonni II - Asteroid Belt 1","position":{"x":-65319198720.0,"y":9657507840.0,"z":155492229120.0},"systemId":30001401}"""

  test "/universe/bloodlines":
    let resp = api.getBloodlines()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/categories":
    let resp = api.getItemCategories()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/categories/16":
    let resp = api.getItemCategory(16)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.categoryId == 16
    assert resp.body.get.name == "Skill"
    assert resp.body.get.published == true
    assert resp.body.get.groups.len > 0

  test "/universe/constellations":
    let resp = api.getConstellations()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/constellations/20000205":
    let resp = api.getConstellation(20000205)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.constellationId == 20000205
    assert resp.body.get.name == "Minnen"

  test "/universe/factions":
    let resp = api.getFactions()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/graphics":
    let resp = api.getGraphics()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/graphics/42":
    let resp = api.getGraphic(42) # Caracal.
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.graphicId == 42
    assert resp.body.get.sofHullName == "cc3_t1"

  test "/universe/groups":
    let resp = api.getGroups()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/groups/26":
    let resp = api.getGroup(26)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.groupId == 26
    assert resp.body.get.name == "Cruiser"

  test "/universe/ids":
    let resp = api.bulkNamesToIds(@["Caracal", "Muninn"])
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.inventoryTypes.len == 2
    assert resp.body.get.inventoryTypes[0].id == 621
    assert resp.body.get.inventoryTypes[0].name == "Caracal"
    assert resp.body.get.inventoryTypes[1].id == 12015
    assert resp.body.get.inventoryTypes[1].name == "Muninn"

  test "/universe/moons/40089228":
    let resp = api.getMoon(40089228)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.moonId == 40089228
    assert resp.body.get.name == "Nonni III - Moon 1"

  test "/universe/names":
    let resp = api.bulkIdsToNames(@[621.int32, 12015.int32])
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len == 2
    assert resp.body.get[0].id == 621
    assert resp.body.get[0].name == "Caracal"
    assert resp.body.get[0].category == "inventory_type"
    assert resp.body.get[1].id == 12015
    assert resp.body.get[1].name == "Muninn"
    assert resp.body.get[1].category == "inventory_type"

  test "/universe/planets/40089224":
    let resp = api.getPlanet(40089224)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.planetId == 40089224
    assert resp.body.get.name == "Nonni I"

  test "/universe/races":
    let resp = api.getRaces()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/regions":
    let resp = api.getRegions()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/regions/10000002":
    let resp = api.getRegion(10000002)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.regionId == 10000002
    assert resp.body.get.name == "The Forge"

  test "/universe/stargates/50001692":
    let resp = api.getStargate(50001692)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.stargateId == 50001692
    assert resp.body.get.name == "Stargate (Aunenen)"

  test "/universe/stars/40089223":
    let resp = api.getStar(40089223)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.name == "Nonni - Star"

  test "/universe/stations/60000982":
    let resp = api.getStation(60000982)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.stationId == 60000982
    assert resp.body.get.name == "Nonni I - Kaalakiota Corporation Factory"

  test "/universe/structures":
    let resp = api.getStructures()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  # TODO `getStructure()` requires an access token, even for public structures!
  # test "/universe/structures/{0]":
  #   # Structures are player-owned and may change over time, so I'm just going to assume we can query for the first one.
  #   let resp1 = api.getStructures()
  #   assert resp1.code == 200
  #   assert resp1.body.isSome
  #   let structureId = resp1.body.get[0]
  #   let resp = api.getStructure(structureId)
  #   assert resp.code == 200
  #   assert resp.body.isSome
  #   echo toJson(resp.body.get.name)

  test "/universe/system_jumps":
    let resp = api.getSystemJumps()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/system_kills":
    let resp = api.getSystemKills()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/systems":
    let resp = api.getSystems()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/universe/systems/30001401":
    let resp = api.getSystem(30001401)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.systemId == 30001401
    assert resp.body.get.name == "Nonni"

  test "/universe/types":
    let resp = api.getTypes()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    assert resp.xpages > 5 # Should be about >50 pages or so.

  test "/universe/types all pages":
    var page = 1.int32
    var resp = api.getTypes(page)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    var xpages = resp.xpages
    while page < xpages:
      sleep(500) # Be polite.
      page += 1
      echo &"fetching types page {page}"
      resp = api.getTypes(page)
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

  test "/universe/types/621":
    let resp = api.getType(621)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.typeId == 621
    assert resp.body.get.name == "Caracal"

