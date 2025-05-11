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
  result = WarpyResponse[GetAncestry]()
  result.code = resp.code
  result.cacheControl = resp.headers["Cache-Control"]
  result.etag = resp.headers["ETag"]
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]

  if resp.code == 200:
    result.body = some(resp.body.fromJson(GetAncestry))

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
  result = WarpyResponse[GetAsteroidBelt]()
  result.code = resp.code
  result.cacheControl = resp.headers["Cache-Control"]
  result.etag = resp.headers["ETag"]
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]

  if resp.code == 200:
    result.body = some(resp.body.fromJson(GetAsteroidBelt))

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
  result = WarpyResponse[GetBloodlines]()
  result.code = resp.code
  result.cacheControl = resp.headers["Cache-Control"]
  result.etag = resp.headers["ETag"]
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]

  if resp.code == 200:
    result.body = some(resp.body.fromJson(GetBloodlines))
