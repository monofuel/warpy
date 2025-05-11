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