import
  std/[strformat, options, options],
  curly, jsony, oats

# https://esi.evetech.net/ui/

type
  Warpy* = ref object
    ## Warpy is the primary interface for interacting with the ESI API.
    curly*: Curly
    host*: string
    endpointVersion*: EndpointVersions
    baseUrl*: string
    userAgent*: string
    maxInFlight*: int
    curlTimeout*: int

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
  EsiPosition* = ref object
    x*: float64
    y*: float64
    z*: float64

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

proc post*(
  api: Warpy,
  path: string,
  body: string,
  ifNoneMatch: string = ""
): Response =
  ## make a POST request to the ESI API.
  var headers: HttpHeaders
  headers["User-Agent"] = api.userAgent
  headers["Accept"] = "application/json"
  headers["Content-Type"] = "application/json"

  echo body

  let resp = api.curly.post(api.baseUrl & path, headers, body, api.curlTimeout)
  if resp.code != 200:
    raise newException(
      WarpyError,
      &"API call {path} failed: {resp.code} {resp.body}"
    )
  result = resp

proc newWarpyResponse*[T](resp: Response): WarpyResponse[T] =
  ## Build a warpy response based on the curly response.
  ## pull out all the standard headers, and for a 200 response, parse the body as json.
  result = WarpyResponse[T]()
  result.code = resp.code
  result.cacheControl = resp.headers["Cache-Control"]
  result.etag = resp.headers["ETag"]
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]
  if resp.code == 200:
    result.body = some(resp.body.fromJson(T))
