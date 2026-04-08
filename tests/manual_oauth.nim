## Manual OAuth test tool for authenticated ESI endpoints.
##
## 1. Create a .env file in the project root with:
##      ESI_CLIENT_ID=your_client_id
##      ESI_SECRET_KEY=your_secret_key
##      ESI_CALLBACK_URL=http://localhost:8089/callback
##
## 2. Register an application at https://developers.eveonline.com/
##    Set the callback URL to http://localhost:8089/callback
##
## 3. Run: nim c -r tests/manual_oauth.nim
##    Then open http://localhost:8089/ in your browser.
##
## Only tests safe read-only (GET) endpoints.

import
  std/[uri, strformat, strutils, options, base64, os],
  mummy, mummy/routers,
  curly, jsony,
  warpy

const
  AuthURI = "https://login.eveonline.com/v2/oauth/authorize/"
  TokenURI = "https://login.eveonline.com/v2/oauth/token"
  Port = 8089

  # Read-only scopes for safe testing.
  Scopes = @[
    "publicData",
    "esi-location.read_location.v1",
    "esi-location.read_online.v1",
    "esi-location.read_ship_type.v1",
    "esi-clones.read_clones.v1",
    "esi-clones.read_implants.v1",
    "esi-skills.read_skills.v1",
    "esi-skills.read_skillqueue.v1",
    "esi-wallet.read_character_wallet.v1",
    "esi-assets.read_assets.v1",
    "esi-killmails.read_killmails.v1",
    "esi-characters.read_blueprints.v1",
    "esi-industry.read_character_jobs.v1",
    "esi-markets.read_character_orders.v1",
    "esi-contracts.read_character_contracts.v1",
    "esi-fittings.read_fittings.v1",
    "esi-characters.read_loyalty.v1",
    "esi-characters.read_medals.v1",
    "esi-characters.read_agents_research.v1",
    "esi-characters.read_fatigue.v1",
    "esi-characters.read_contacts.v1",
    "esi-mail.read_mail.v1",
    "esi-fleets.read_fleet.v1",
    "esi-calendar.read_calendar_events.v1",
    "esi-characters.read_fw_stats.v1",
    "esi-industry.read_character_mining.v1",
  ]

type
  TokenResponse = ref object
    accessToken*: string
    tokenType*: string
    expiresIn*: int
    refreshToken*: string
    error*: string
    errorDescription*: string

  JwtPayload = ref object
    sub*: string      # "CHARACTER:EVE:12345678"
    name*: string     # Character name
    scp*: seq[string] # Scopes

var
  clientID: string
  secretKey: string
  callbackURL: string

proc loadDotEnv() =
  ## Load .env file from project root.
  let envPath = ".env"
  if not fileExists(envPath):
    echo "ERROR: .env file not found. Create one with ESI_CLIENT_ID, ESI_SECRET_KEY, ESI_CALLBACK_URL"
    quit(1)

  for line in lines(envPath):
    let stripped = line.strip()
    if stripped.len == 0 or stripped.startsWith("#"):
      continue
    let parts = stripped.split("=", maxsplit = 1)
    if parts.len == 2:
      putEnv(parts[0].strip(), parts[1].strip())

  clientID = getEnv("ESI_CLIENT_ID")
  secretKey = getEnv("ESI_SECRET_KEY")
  callbackURL = getEnv("ESI_CALLBACK_URL", &"http://localhost:{Port}/callback")

  if clientID == "" or secretKey == "":
    echo "ERROR: ESI_CLIENT_ID and ESI_SECRET_KEY must be set in .env"
    quit(1)

proc exchangeCode(code: string): TokenResponse {.gcsafe.} =
  var cid, skey: string
  {.gcsafe.}:
    cid = clientID
    skey = secretKey

  let curl = newCurly()
  var headers: curly.HttpHeaders
  let base64Auth = encode(&"{cid}:{skey}")
  headers["Authorization"] = &"Basic {base64Auth}"
  headers["Content-Type"] = "application/x-www-form-urlencoded"
  headers["User-Agent"] = "warpy"
  headers["Host"] = "login.eveonline.com"

  var params: seq[(string, string)] = @[]
  params.add(("grant_type", "authorization_code"))
  params.add(("code", code))
  let body = encodeQuery(params)

  let resp = curl.post($parseUri(TokenURI), headers, body)
  if resp.code != 200:
    echo &"Token exchange failed: {resp.code} {resp.body}"
    quit(1)
  result = fromJson(resp.body, TokenResponse)

proc decodeJwt(accessToken: string): JwtPayload =
  ## Decode the JWT payload to extract character info.
  let parts = accessToken.split(".")
  if parts.len != 3:
    echo "ERROR: Access token is not a valid JWT"
    quit(1)
  # JWT uses base64url encoding -- pad and decode the payload.
  var payload = parts[1]
  while payload.len mod 4 != 0:
    payload &= "="
  # base64url -> base64
  payload = payload.replace('-', '+').replace('_', '/')
  let decoded = decode(payload)
  result = fromJson(decoded, JwtPayload)

proc runAuthenticatedTests(accessToken: string, characterId: int32) =
  ## Run safe read-only tests against authenticated endpoints using warpy.
  let api = newWarpy(accessToken = accessToken)

  echo ""
  echo "=== Authenticated Endpoint Tests ==="
  echo &"Character ID: {characterId}"
  echo ""

  type TestEndpoint = tuple[name: string, path: string]
  let endpoints: seq[TestEndpoint] = @[
    ("Location", &"/characters/{characterId}/location/"),
    ("Online", &"/characters/{characterId}/online/"),
    ("Ship", &"/characters/{characterId}/ship/"),
    ("Skills", &"/characters/{characterId}/skills/"),
    ("Skill Queue", &"/characters/{characterId}/skillqueue/"),
    ("Wallet", &"/characters/{characterId}/wallet/"),
    ("Assets", &"/characters/{characterId}/assets/"),
    ("Implants", &"/characters/{characterId}/implants/"),
    ("Clones", &"/characters/{characterId}/clones/"),
    ("Blueprints", &"/characters/{characterId}/blueprints/"),
    ("Industry Jobs", &"/characters/{characterId}/industry/jobs/"),
    ("Contracts", &"/characters/{characterId}/contracts/"),
    ("Fittings", &"/characters/{characterId}/fittings/"),
    ("Loyalty Points", &"/characters/{characterId}/loyalty/points/"),
    ("Mail", &"/characters/{characterId}/mail/"),
    ("Calendar", &"/characters/{characterId}/calendar/"),
    ("Medals", &"/characters/{characterId}/medals/"),
    ("Agents Research", &"/characters/{characterId}/agents_research/"),
    ("Fatigue", &"/characters/{characterId}/fatigue/"),
    ("Contacts", &"/characters/{characterId}/contacts/"),
    ("Recent Killmails", &"/characters/{characterId}/killmails/recent/"),
    ("FW Stats", &"/characters/{characterId}/fw/stats/"),
    ("Mining", &"/characters/{characterId}/mining/"),
  ]

  var passed = 0
  var failed = 0
  for ep in endpoints:
    try:
      let resp = api.get(ep.path)
      echo &"  [OK]   {ep.name} ({resp.body.len} bytes)"
      passed += 1
    except WarpyError:
      echo &"  [FAIL] {ep.name} -> {getCurrentExceptionMsg()}"
      failed += 1
    except:
      echo &"  [ERR]  {ep.name} -> {getCurrentExceptionMsg()}"
      failed += 1

  echo ""
  echo &"Results: {passed} passed, {failed} failed"

proc indexHandler(request: Request) {.gcsafe.} =
  var cid, cburl: string
  {.gcsafe.}:
    cid = clientID
    cburl = callbackURL

  let scopeStr = Scopes.join(" ")
  var authUri = parseUri(AuthURI)
  var params: seq[(string, string)] = @[]
  params.add(("response_type", "code"))
  params.add(("client_id", cid))
  params.add(("redirect_uri", cburl))
  params.add(("scope", scopeStr))
  params.add(("state", "warpy_test"))
  authUri = authUri ? params

  let html = &"""<!DOCTYPE html>
<html><body>
<h1>Warpy OAuth Test</h1>
<p><a href="{authUri}">Log in with EVE Online</a></p>
<p>This will request read-only scopes and run safe GET endpoint tests.</p>
</body></html>"""

  var headers: mummy.HttpHeaders
  headers["Content-Type"] = "text/html"
  request.respond(200, headers, html)

proc callbackHandler(request: Request) {.gcsafe.} =
  let uri = parseUri(request.uri)
  var code = ""
  for key, val in decodeQuery(uri.query):
    if key == "code":
      code = val

  if code == "":
    var headers: mummy.HttpHeaders
    request.respond(400, headers, "Missing authorization code")
    return

  echo "Received authorization code, exchanging for token..."
  let token = exchangeCode(code)

  if token.error != "":
    echo &"OAuth error: {token.error} - {token.errorDescription}"
    var headers: mummy.HttpHeaders
    request.respond(500, headers, &"OAuth error: {token.error}")
    return

  echo "Token received, decoding JWT..."
  let jwt = decodeJwt(token.accessToken)
  # sub format: "CHARACTER:EVE:12345678"
  let charIdStr = jwt.sub.split(":")[^1]
  let charId = int32(parseInt(charIdStr))
  echo &"Authenticated as: {jwt.name} ({charId})"

  var headers: mummy.HttpHeaders
  headers["Content-Type"] = "text/html"
  request.respond(200, headers, &"""<!DOCTYPE html>
<html><body>
<h1>Authenticated!</h1>
<p>Character: {jwt.name} ({charId})</p>
<p>Running tests... check the terminal.</p>
</body></html>""")

  runAuthenticatedTests(token.accessToken, charId)

  echo ""
  echo "Tests complete. Press Ctrl+C to stop the server."

proc main() =
  loadDotEnv()

  echo &"Starting OAuth test server on http://localhost:{Port}/"
  echo "Open that URL in your browser to begin."
  echo ""

  var router: Router
  router.get("/", indexHandler)
  router.get("/callback", callbackHandler)

  let server = newServer(router)
  server.serve(mummy.Port(Port))

when isMainModule:
  main()
