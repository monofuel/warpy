import
  std/[strformat, options, tables],
  curly, jsony,
  ../core

type
  ChangelogEntry* = ref object
    `method`*: string            # HTTP method of the route.
    path*: string                # Path of the route.
    compatibilityDate*: string   # Compatibility date of the route.
    isBreaking*: bool            # Whether this is a breaking change.
    description*: string         # Description of the change.

  Changelog* = ref object
    changelog*: Table[string, seq[ChangelogEntry]]  # Per date, list changes for that date.

  CompatibilityDates* = ref object
    compatibilityDates*: seq[string]  # List of compatibility dates.

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


proc getChangelog*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[Changelog] =
  ## Get the changelog of this API.
  var headers: HttpHeaders
  headers["User-Agent"] = api.userAgent
  headers["Accept"] = "application/json"
  if ifNoneMatch != "":
    headers["If-None-Match"] = ifNoneMatch

  let resp = api.curly.get(api.host & "/meta/changelog", headers, api.curlTimeout)
  if resp.code != 200 and resp.code != 304:
    raise newException(
      WarpyError,
      &"API call /meta/changelog failed: {resp.code} {resp.body}"
    )
  result = WarpyResponse[Changelog]()
  result.code = resp.code
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]
  result.cacheControl = resp.headers["Cache-Control"]
  if resp.code == 200:
    result.body = some(resp.body.fromJson(Changelog))

proc getCompatibilityDates*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[CompatibilityDates] =
  ## Get a list of compatibility dates.
  var headers: HttpHeaders
  headers["User-Agent"] = api.userAgent
  headers["Accept"] = "application/json"
  if ifNoneMatch != "":
    headers["If-None-Match"] = ifNoneMatch

  let resp = api.curly.get(api.host & "/meta/compatibility-dates", headers, api.curlTimeout)
  if resp.code != 200 and resp.code != 304:
    raise newException(
      WarpyError,
      &"API call /meta/compatibility-dates failed: {resp.code} {resp.body}"
    )
  result = WarpyResponse[CompatibilityDates]()
  result.code = resp.code
  result.expires = resp.headers["Expires"]
  result.lastModified = resp.headers["Last-Modified"]
  result.cacheControl = resp.headers["Cache-Control"]
  if resp.code == 200:
    result.body = some(resp.body.fromJson(CompatibilityDates))
