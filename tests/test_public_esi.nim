# test Public ESI API endpoints
import std/[unittest, os, strformat, options], warpy, jsony


suite "Public ESI API":
  var api: Warpy
  setup:
    api = newWarpy()

  suite "Status":
    test "/status":
      let resp = api.getStatus()
      assert resp.code == 200
      assert resp.body.isSome
      echo toJson(resp.body.get)

    test "/status with etag":
      # this test verifies that etags work properly
      let resp1 = api.getStatus()
      assert resp1.code == 200
      assert resp1.body.isSome
      echo resp1.etag
      let resp2 = api.getStatus(resp1.etag)
      assert resp2.code == 304 # etag match should return 304
      assert resp2.body.isNone # body should be empty, no new data

  suite "Universe":
    test "/universe/ancestries":
      # TODO test languages
      let resp = api.getAncestries()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

    test "/universe/asteroid_belts":
      const asteroidBeltId = 40089226 # Belt in the Nonni system
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
      let resp = api.getGraphic(42) # caracal
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
      assert resp.xpages > 5 # should be about >50 pages or so

    test "/universe/types all pages":
      var page = 1.int32
      var resp = api.getTypes(page)
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
      var xpages = resp.xpages
      while page < xpages:
        sleep(500) # be polite
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

  suite "Meta":
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
      # sanity check that latest exists
      assert resp.body.get.find("latest") != -1

  suite "Wars":
    test "/wars":
      let resp = api.getWars()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0

    test "/wars with max_war_id":
      let resp = api.getWars(maxWarId = 500000)
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
      # All returned war IDs should be less than or equal to max_war_id.
      for warId in resp.body.get:
        assert warId <= 500000

    test "/wars/{war_id}":
      # Get a recent war ID first.
      let warsResp = api.getWars()
      assert warsResp.code == 200
      assert warsResp.body.isSome
      assert warsResp.body.get.len > 0

      let warId = warsResp.body.get[0]
      let resp = api.getWar(warId)
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.id == warId
      assert resp.body.get.declared != ""
      assert resp.body.get.aggressor != nil
      assert resp.body.get.defender != nil

    test "/wars/{war_id}/killmails":
      # Get a recent war ID first.
      let warsResp = api.getWars()
      assert warsResp.code == 200
      assert warsResp.body.isSome
      assert warsResp.body.get.len > 0

      let warId = warsResp.body.get[0]
      let resp = api.getWarKillmails(warId)
      assert resp.code == 200
      assert resp.body.isSome
      # May not have killmails, but the response should be valid.
      assert resp.body.get.len >= 0

  suite "Sovereignty":
    test "/sovereignty/campaigns":
      let resp = api.getSovereigntyCampaigns()
      assert resp.code == 200
      assert resp.body.isSome
      # May not always have active campaigns, but response should be valid.
      assert resp.body.get.len >= 0

    test "/sovereignty/map":
      let resp = api.getSovereigntyMap()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
      # Check that systems have IDs.
      for system in resp.body.get:
        assert system.systemId > 0

    test "/sovereignty/structures":
      let resp = api.getSovereigntyStructures()
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
      # Check that structures have required fields.
      for structure in resp.body.get:
        assert structure.structureId > 0
        assert structure.allianceId > 0
        assert structure.solarSystemId > 0
        assert structure.structureTypeId > 0

  suite "Routes":
    test "/route/{origin}/{destination}":
      # Route from Jita (30000142) to Amarr (30002187).
      let resp = api.getRoute(origin = 30000142, destination = 30002187)
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
      # First system should be origin, last should be destination.
      assert resp.body.get[0] == 30000142
      assert resp.body.get[^1] == 30002187

    test "/route with avoid":
      # Route from Jita to Amarr, avoiding Niarja (30002659).
      let resp = api.getRoute(
        origin = 30000142,
        destination = 30002187,
        avoid = @[30002659.int32]
      )
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
      # Niarja should not be in the route.
      assert 30002659.int32 notin resp.body.get

    test "/route with flag":
      # Secure route.
      let resp = api.getRoute(
        origin = 30000142,
        destination = 30002187,
        flag = secure
      )
      assert resp.code == 200
      assert resp.body.isSome
      assert resp.body.get.len > 0
