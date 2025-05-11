import 
  std/[strformat, options],
  curly, jsony,
  ../core

type
  StatusJsonRow* = ref object
    endpoint*: string
    `method`*: string
    route*: string
    status*: string # "green" "yellow" "red"
    tags*: seq[string]
  StatusJson* = seq[StatusJsonRow]
  Versions* = seq[string]

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
