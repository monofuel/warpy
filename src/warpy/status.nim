import std/[options], curly, jsony, ../core

type
  GetStatus* = ref object
    players*: int          # current online player count
    serverVersion*: string # Running version as a string
    startTime*: string     # Server start timestamp
    vip*: bool             # If the server is in VIP mode (aka developers testing on prod)

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