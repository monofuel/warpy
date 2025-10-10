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

type
  GetMoon* = ref object
    moonId*: int32
    name*: string
    position*: EsiPosition
    systemId*: int32
  GetMoons* = seq[GetMoon]

proc getMoon*(
  api: Warpy,
  moonId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[GetMoon] =
  ## get information for a moon
  let resp = api.get("/universe/moons/" & $moonId, ifNoneMatch)
  result = newWarpyResponse[GetMoon](resp)

type
  IdToName* = ref object
    category*: string
    id*: int32
    name*: string
  BulkIdsToNames* = seq[IdToName]

proc bulkIdsToNames*(
  api: Warpy,
  ids: seq[int32],
): WarpyResponse[BulkIdsToNames] =
  ## bulk get names from a list of IDs.
  ## all IDs must resolve to names, or none are returned.

  assert ids.len > 0
  assert ids.len <= 1000

  let resp = api.post("/universe/names/", toJson(ids))
  result = newWarpyResponse[BulkIdsToNames](resp)

type
  GetPlanet* = ref object
    name*: string
    planetId*: int32
    position*: EsiPosition
    systemId*: int32
    typeId*: int32

proc getPlanet*(
  api: Warpy,
  planetId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[GetPlanet] =
  ## get information for a planet
  let resp = api.get("/universe/planets/" & $planetId, ifNoneMatch)
  result = newWarpyResponse[GetPlanet](resp)

type
  Race* = ref object
    allianceId*: int32
    description*: string
    name*: string
    raceId*: int32

proc getRaces*(
  api: Warpy,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[seq[Race]] =
  ## get all races
  let resp = api.get("/universe/races?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[seq[Race]](resp)

proc getRegions*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## get all region IDs
  let resp = api.get("/universe/regions", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

type
  Region* = ref object
    regionId*: int32
    description*: string
    name*: string
    constellations*: seq[int32]

proc getRegion*(
  api: Warpy,
  regionId: int32,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[Region] =
  ## get information for a region
  let resp = api.get("/universe/regions/" & $regionId & "?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[Region](resp)

type
  StargateDestination* = ref object
    stargateId*: int32
    systemId*: int32
  Stargate* = ref object
    destination*: StargateDestination
    name*: string
    position*: EsiPosition
    stargateId*: int32
    systemId*: int32
    typeId*: int32

proc getStargate*(
  api: Warpy,
  stargateId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[Stargate] =
  ## get information for a stargate
  let resp = api.get("/universe/stargates/" & $stargateId, ifNoneMatch)
  result = newWarpyResponse[Stargate](resp)

type
  Star* = ref object
    age*: int64
    luminosity*: float
    name*: string
    radius*: int64
    solarSystemId*: int32
    spectralClass*: string
    temperature*: int32
    typeId*: int32

proc getStar*(
  api: Warpy,
  starId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[Star] =
  ## get information for a star
  let resp = api.get("/universe/stars/" & $starId, ifNoneMatch)
  result = newWarpyResponse[Star](resp)

type
  Station* = ref object
    maxDockableShipVolume*: float
    name*: string
    officeRentalCost*: float
    owner*: int32
    position*: EsiPosition
    raceId*: int32
    reprocessingEfficiency*: float
    reprocessingStationsTake*: float
    services*: seq[string]
    stationId*: int32
    systemId*: int32
    typeId*: int32

proc getStation*(
  api: Warpy,
  stationId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[Station] =
  ## get information for a station
  let resp = api.get("/universe/stations/" & $stationId, ifNoneMatch)
  result = newWarpyResponse[Station](resp)

# NB. Structure IDs are int64!

proc getStructures*(
  api: Warpy,
  filter: string = "", # can filter to structures with "market" or "manufacturing_basic"
  ifNoneMatch: string = ""
): WarpyResponse[seq[int64]] =
  ## list public structures.
  ## will return up to 10k structure IDs.
  var url = "/universe/structures"
  if filter != "":
    url.add "?filter=" & filter
  let resp = api.get(url, ifNoneMatch)
  result = newWarpyResponse[seq[int64]](resp)

type
  Structure* = ref object
    name*: string
    ownerId*: int32
    position*: EsiPosition
    solarSystemId*: int32
    typeId*: int32

proc getStructure*(
  api: Warpy,
  structureId: int64,
  ifNoneMatch: string = ""
): WarpyResponse[Structure] =
  ## get information for a structure
  let resp = api.get("/universe/structures/" & $structureId, ifNoneMatch)
  result = newWarpyResponse[Structure](resp)

type
  SystemJumps* = ref object
    shipJumps*: int32
    systemId*: int32
  GetSystemJumps* = seq[SystemJumps]

proc getSystemJumps*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[GetSystemJumps] =
  ## get number of jumps in the last hour, for every solar system, excluding wormhole space
  ## systems without any jumps are not included.
  let resp = api.get("/universe/system_jumps", ifNoneMatch)
  result = newWarpyResponse[GetSystemJumps](resp)

type
  SystemKills* = ref object
    npcKills*: int32
    podKills*: int32
    shipKills*: int32
    systemId*: int32
  GetSystemKills* = seq[SystemKills]

proc getSystemKills*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[GetSystemKills] =
  ## get number of ship, pod, and NPC kills in the last hour, for every solar system, excluding wormhole space,
  ## systems without any kills are not included.
  let resp = api.get("/universe/system_kills", ifNoneMatch)
  result = newWarpyResponse[GetSystemKills](resp)


proc getSystems*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## get all solar system IDs
  let resp = api.get("/universe/systems", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

type
  Planet* = ref object
    asteroidBelts*: seq[int32]
    moons*: seq[int32]
    planetId*: int32

  System* = ref object
    constellationId*: int32
    name*: string
    planets*: seq[Planet]
    position*: EsiPosition
    securityClass*: string
    securityStatus*: float
    starId*: int32
    stargates*: seq[int32]
    stations*: seq[int32]
    systemId*: int32
  GetSystems* = seq[System]

proc getSystem*(
  api: Warpy,
  systemId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[System] =
  ## get information for a solar system
  let resp = api.get("/universe/systems/" & $systemId, ifNoneMatch)
  result = newWarpyResponse[System](resp)

proc getTypes*(
  api: Warpy,
  page: int32 = 1,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## get all type IDs
  let resp = api.get("/universe/types?page=" & $page, ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

type
  DogmaAttribute* = ref object
    attributeId*: int32
    value*: float
  DogmaEffect* = ref object
    effectId*: int32
    isDefault*: bool
  Type* = ref object
    capacity*: float
    description*: string
    dogmaAttributes*: seq[DogmaAttribute]
    dogmaEffects*: seq[DogmaEffect]
    graphicId*: int32
    groupId*: int32
    iconId*: int32
    marketGroupID*: int32
    mass*: float
    name*: string
    packagedVolume*: float
    portionSize*: int32
    published*: bool
    radius*: float
    typeId*: int32
    volume*: float

proc getType*(
  api: Warpy,
  typeId: int32,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[Type] =
  ## get information for a type
  let resp = api.get("/universe/types/" & $typeId & "?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[Type](resp)

type
  Schematic* = ref object
    schematicName*: string  # Name of the schematic.
    cycleTime*: int32       # Time in seconds to process a run.

proc getSchematic*(
  api: Warpy,
  schematicId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[Schematic] =
  ## Get information on a planetary factory schematic.
  let resp = api.get("/universe/schematics/" & $schematicId, ifNoneMatch)
  result = newWarpyResponse[Schematic](resp)
