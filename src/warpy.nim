import
  std/[strformat, options, options],
  curly, jsony, oats

# https://esi.evetech.net/ui/

type
  Warpy* = ref object
    ## Warpy is the primary interface for interacting with the ESI API.
    curly: Curly
    host: string
    endpointVersion: EndpointVersions
    baseUrl: string
    userAgent: string
    maxInFlight: int
    curlTimeout: int

  WarpyError* = object of CatchableError
  WarpyResponse*[T] = ref object
    ## WarpyResponse wraps around the response object to provide other data like cache headers.
    ## Make sure to check that code is 200 before accessing the body.
    code*: int            # HTTP status code
    body*: Option[T]       # response body. will be none(T) if the response code is not 200 (eg: 304 no change)
    cacheControl*: string # caching mechanism used
    etag*: string         # RFC7232 ETag for change detection
    expires*: string      # RFC7231 Expires header
    lastModified*: string # RFC7231 Last-Modified header

  GetStatus* = ref object
    players: int          # current online player count
    serverVersion: string # Running version as a string
    startTime: string     # Server start timestamp
    vip: bool             # If the server is in VIP mode (aka developers testing on prod)
  Ancestry* = ref object
    id*: int32
    iconId*: int32 # optional
    name*: string
    bloodlineId*: int32
    description*: string
    shortDescription*: string # optional
  GetAncestry* = seq[Ancestry]
  StatusJsonRow* = ref object
    endpoint*: string
    `method`*: string
    route*: string
    status*: string # "green" "yellow" "red"
    tags*: seq[string]
  StatusJson* = seq[StatusJsonRow]
  Versions* = seq[string]

  
  EsiLanguage* = enum
    en = "en",
    en_us = "en-us",
    de = "de",
    fr = "fr",
    ja = "ja",
    ru = "ru",
    zh = "zh"
  EndpointVersions* = enum
    dev = "dev",
    legacy = "legacy",
    latest = "latest",
    v1 = "v1",
    v2 = "v2",
    v3 = "v3",
    v4 = "v4",
    v5 = "v5",
    v6 = "v6"

const
  DefaultUserAgent = "warpy"
  DefaultHost = "https://esi.evetech.net"
  DefaultVersion = EndpointVersions.latest
  

proc newWarpy*(
  host: string = DefaultHost,
  endpointVersion: EndpointVersions = DefaultVersion,
  userAgent: string = DefaultUserAgent,
  maxInFlight: int = 16,
  curlTimeout: int = 60
): Warpy =
  ## create a new warpy instance
  result = Warpy()
  result.curly = newCurly(maxInFlight)
  result.host = host
  result.endpointVersion = endpointVersion
  result.baseUrl = host & "/" & $endpointVersion
  echo result.baseUrl
  result.userAgent = userAgent
  result.curlTimeout = curlTimeout


proc get*(
  api: Warpy,
  path: string,
  ifNoneMatch: string = "",
  # TODO character stuff
): Response =
  ## make a GET request to the ESI API.
  ## ifNoneMatch can be used to provide an ETag for change detection
  var headers: HttpHeaders
  headers["User-Agent"] = api.userAgent
  headers["Accept"] = "application/json"
  
  if ifNoneMatch != "":
    headers["If-None-Match"] = ifNoneMatch

  let resp = api.curly.get(api.baseUrl & path, headers, api.curlTimeout)
  if resp.code != 200 and resp.code != 304:
    raise newException(
      WarpyError,
      &"API call {path} failed: {resp.code} {resp.body}"
    )
  result = resp

# ------------------------------------------------------------------------------------------------
# Status
# ------------------------------------------------------------------------------------------------

proc getStatus*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[GetStatus] =
  ## get the status of the server
  
  # `datasource` is an allowed query parameter, but `tranquility` is the only valid value, and is the default

  let resp = api.get("/status", ifNoneMatch)
  result = WarpyResponse[GetStatus]()
  result.code = resp.code
  result.cacheControl = resp.headers["Cache-Control"]
  result.etag = resp.headers["ETag"]
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]

  if resp.code == 200:
    result.body = some(resp.body.fromJson(GetStatus))

# ------------------------------------------------------------------------------------------------
# Universe
# ------------------------------------------------------------------------------------------------

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


# ------------------------------------------------------------------------------------------------
# Meta
# ------------------------------------------------------------------------------------------------

# meta endpoints exist at the root of the API, not versioned

# /headers/ can be used to echo the request headers for debugging purpose
# omitting this from the client library

proc ping*(
  api: Warpy
): WarpyResponse[string] =
  ## ping the ESI routers
  
  var headers: HttpHeaders
  headers["User-Agent"] = api.userAgent
  headers["Accept"] = "application/json"

  let resp = api.curly.get(api.host & "/ping", headers, api.curlTimeout)
  if resp.code != 200:
    raise newException(
      WarpyError,
      &"API call /ping failed: {resp.code} {resp.body}"
    )
  result = WarpyResponse[string]()
  result.code = resp.code
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]
  result.cacheControl = resp.headers["Cache-Control"]
  result.body = some(resp.body)


proc statusJson*(
  api: Warpy
): WarpyResponse[StatusJson] =
  ## Provides a general health indicator per route and method

  var headers: HttpHeaders
  headers["User-Agent"] = api.userAgent
  headers["Accept"] = "application/json"

  let resp = api.curly.get(api.host & "/status.json", headers, api.curlTimeout)
  if resp.code != 200:
    raise newException(
      WarpyError,
      &"API call /status.json failed: {resp.code} {resp.body}"
    )
  result = WarpyResponse[StatusJson]()
  result.code = resp.code
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]
  result.cacheControl = resp.headers["Cache-Control"]
  result.body = some(resp.body.fromJson(StatusJson))

# verify
# TODO, verifies the charcter for the authorization token

# versions

proc getVersions*(
  api: Warpy
): WarpyResponse[Versions] =
  ## get the available versions of the ESI API
  var headers: HttpHeaders
  headers["User-Agent"] = api.userAgent
  headers["Accept"] = "application/json"

  let resp = api.curly.get(api.host & "/versions", headers, api.curlTimeout)
  if resp.code != 200:
    raise newException(
      WarpyError,
      &"API call /versions failed: {resp.code} {resp.body}"
    )
  result = WarpyResponse[Versions]()
  result.code = resp.code
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]
  result.cacheControl = resp.headers["Cache-Control"]
  result.body = some(resp.body.fromJson(Versions))
