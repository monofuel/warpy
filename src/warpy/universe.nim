import std/[options, json], curly, jsony, ../core

type
  Ancestry* = ref object
    id*: int32
    iconId*: int32 # optional
    name*: string
    bloodlineId*: int32
    description*: string
    shortDescription*: string # optional
  GetAncestry* = seq[Ancestry]

proc getAncestries*(
  api: Warpy,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[GetAncestry] =
  ## get all character ancestries
  let resp = api.get("/universe/ancestries?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[GetAncestry](resp)

type
  GetAsteroidBelt* = ref object
    name*: string
    position*: EsiPosition
    systemId*: int32

proc getAsteroidBelts*(
  api: Warpy,
  asteroidBeltId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[GetAsteroidBelt] =
  ## get asteroid belt information
  let resp = api.get("/universe/asteroid_belts/" & $asteroidBeltId, ifNoneMatch)
  result = newWarpyResponse[GetAsteroidBelt](resp)

type
  Bloodline* = ref object
    bloodlineId*: int32
    charisma*: int32
    corporationId*: int32
    description*: string
    intelligence*: int32
    memory*: int32
    name*: string
    perception*: int32
    raceId*: int32
    shipTypeId*: Option[int32] # may be null
    willpower*: int32
  GetBloodlines* = seq[Bloodline]

proc getBloodlines*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[GetBloodlines] =
  ## get all bloodlines
  let resp = api.get("/universe/bloodlines", ifNoneMatch)
  result = newWarpyResponse[GetBloodlines](resp)

proc getItemCategories*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## get all item category IDs
  let resp = api.get("/universe/categories", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

type
  ItemCategory* = ref object
    categoryId*: int32
    groups*: seq[int32]
    name*: string
    published*: bool

proc getItemCategory*(
  api: Warpy,
  categoryId: int32,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[ItemCategory] =
  ## get item category information
  let resp = api.get("/universe/categories/" & $categoryId & "?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[ItemCategory](resp)

proc getConstellations*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## get all constellation IDs.
  ## This route expires daily at 1105
  let resp = api.get("/universe/constellations", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

type
  Constellation* = ref object
    constellationId*: int32
    name*: string
    position*: EsiPosition
    regionId*: int32
    systems*: seq[int32]

proc getConstellation*(
  api: Warpy,
  constellationId: int32,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[Constellation] =
  ## get constellation information
  let resp = api.get("/universe/constellations/" & $constellationId & "?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[Constellation](resp)

type
  Faction* = ref object
    corporationId*: Option[int32]
    description*: string
    factionId*: int32
    isUnique*: bool
    militiaCorporationId*: Option[int32]
    name*: string
    sizeFactor*: float
    solarSystemId*: Option[int32]
    stationCount*: int32
    stationSystemCount*: int32
  GetFactions* = seq[Faction]

proc getFactions*(
  api: Warpy,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[GetFactions] =
  ## get all factions
  let resp = api.get("/universe/factions?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[GetFactions](resp)

proc getGraphics*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## get list of graphic IDs
  let resp = api.get("/universe/graphics/", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

type
  Graphic* = ref object
    collisionFile*: string
    graphicFile*: string
    graphicId*: int32
    iconFolder*: string
    sofDna*: string
    sofFationName*: string
    sofHullName*: string
    sofRaceName*: string

proc getGraphic*(
  api: Warpy,
  graphicId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[Graphic] =
  ## get graphic information
  let resp = api.get("/universe/graphics/" & $graphicId, ifNoneMatch)
  result = newWarpyResponse[Graphic](resp)


proc getGroups*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## get list of item group IDs
  let resp = api.get("/universe/groups", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

type
  Group* = ref object
    categoryId*: int32
    groupId*: int32
    name*: string
    published*: bool
    types*: seq[int32]

proc getGroup*(
  api: Warpy,
  groupId: int32,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[Group] =
  ## get item group information
  let resp = api.get("/universe/groups/" & $groupId & "?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[Group](resp)

type
  NameToId* = ref object
    id*: int32
    name*: string
  BulkNamesToIds* = ref object
    agents*: seq[NameToId]
    characters*: seq[NameToId]
    constellations*: seq[NameToId]
    corporations*: seq[NameToId]
    factions*: seq[NameToId]
    inventoryTypes*: seq[NameToId]
    regions*: seq[NameToId]
    stations*: seq[NameToId]
    systems*: seq[NameToId]

proc bulkNamesToIds*(
  api: Warpy,
  names: seq[string],
  language: EsiLanguage = en
): WarpyResponse[BulkNamesToIds] =
  ## bulk get item IDs from a list of names.
  ## any names that do not have a match will be omitted from the response.

  assert names.len > 0
  assert names.len <= 500

  # POST /universe/ids/
  let resp = api.post("/universe/ids?language=" & $language, toJson(names))
  result = newWarpyResponse[BulkNamesToIds](resp)
