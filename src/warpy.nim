import
  std/[strformat, options, options],
  curly, jsony

# https://esi.evetech.net/ui/

type
  Warpy* = ref object
    curly: Curly
    baseUrl: string
    userAgent: string
    maxInFlight: int
    curlTimeout: int

  WarpyError* = object of CatchableError

  GetStatus* = ref object
    players: int          # current online player count
    serverVersion: string # Running version as a string
    startTime: string     # Server start timestamp
    vip: bool             # If the server is in VIP mode
  WarpyResponse*[T] = ref object
    code*: int            # HTTP status code
    body*: Option[T]       # response body. will be none(T) if the response code is not 200 (eg: 304 no change)
    cacheControl*: string # caching mechanism used
    etag*: string         # RFC7232 ETag for change detection
    expires*: string      # RFC7231 Expires header
    lastModified*: string # RFC7231 Last-Modified header


const
  DefaultUserAgent = "warpy"
  DefaultHost = "https://esi.evetech.net/latest"

proc newWarpy*(
  baseUrl: string = DefaultHost,
  userAgent: string = DefaultUserAgent,
  maxInFlight: int = 16,
  curlTimeout: int = 60
): Warpy =
  ## create a new warpy instance
  result = Warpy()
  result.curly = newCurly(maxInFlight)
  result.baseUrl = baseUrl
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
