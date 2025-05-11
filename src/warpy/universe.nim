import std/[options], curly, jsony, ../core

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
  ifNoneMatch: string = ""
): WarpyResponse[Constellation] =
  ## get constellation information
  let resp = api.get("/universe/constellations/" & $constellationId, ifNoneMatch)
  result = newWarpyResponse[Constellation](resp)
