import
  std/[strutils],
  ../core

type
  Connection* = tuple[fromSystem: int32, toSystem: int32]

  RouteFlag* = enum
    ## Route security preference.
    shortest,   # Shortest route (default).
    secure,     # Prefer secure routes.
    insecure    # Prefer insecure routes.

proc getRoute*(
  api: Warpy,
  origin: int32,
  destination: int32,
  avoid: seq[int32] = @[],
  connections: seq[Connection] = @[],
  flag: RouteFlag = shortest,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## Get the systems between origin and destination.
  ##
  ## Parameters:
  ## - origin: Origin solar system ID.
  ## - destination: Destination solar system ID.
  ## - avoid: List of solar system IDs to avoid.
  ## - connections: List of connected solar system pairs (for wormholes).
  ## - flag: Routing flag (shortest, secure, insecure). Default is shortest.
  ## - ifNoneMatch: ETag for caching.

  var url = "/route/" & $origin & "/" & $destination
  var params: seq[string] = @[]

  # Add avoid systems.
  if avoid.len > 0:
    for systemId in avoid:
      params.add("avoid=" & $systemId)

  # Add connections.
  if connections.len > 0:
    for conn in connections:
      params.add("connections=" & $conn.fromSystem & "," & $conn.toSystem)

  # Add flag (always add since we have a default).
  params.add("flag=" & $flag)

  # Build final URL.
  if params.len > 0:
    url &= "?" & params.join("&")

  let resp = api.get(url, ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

