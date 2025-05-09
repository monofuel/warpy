import
  std/[strformat],
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
    players: int # current online player count
    serverVersion: string # Running version as a string
    startTime: string # Server start timestamp
    vip: bool # If the server is in VIP mode

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
  # TODO character stuff
): Response =
  ## make a GET request to the ESI API
  var headers: HttpHeaders
  headers["User-Agent"] = api.userAgent
  headers["Accept"] = "application/json"

  let resp = api.curly.get(api.baseUrl & path, headers, api.curlTimeout)
  if resp.code != 200:
    raise newException(
      WarpyError,
      &"API call {path} failed: {resp.code} {resp.body}"
    )
  result = resp


proc getStatus*(
  api: Warpy,
): GetStatus =
  ## get the status of the server
  
  # `datasource` is an allowed query parameter, but `tranquility` is the only valid value, and is the default

  let resp = api.get("/status")
  result = resp.body.fromJson(GetStatus)
