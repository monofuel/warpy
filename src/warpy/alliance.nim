import
  std/[options],
  curly, jsony,
  ../core

type
  Alliance* = ref object
    creatorCorporationId*: int32       # Alliance's creator corporation ID.
    creatorId*: int32                  # Alliance's creator character ID.
    dateFounded*: string               # Alliance's founding date.
    executorCorporationId*: Option[int32]  # Executor corporation ID.
    factionId*: Option[int32]          # Faction ID if allied with a faction.
    name*: string                      # Alliance name.
    ticker*: string                    # Alliance ticker.

  AllianceIcons* = ref object
    px64x64*: Option[string]           # 64x64 icon URL.
    px128x128*: Option[string]         # 128x128 icon URL.

proc getAlliances*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## List all active player alliances.
  let resp = api.get("/alliances", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

proc getAlliance*(
  api: Warpy,
  allianceId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[Alliance] =
  ## Get public information about an alliance.
  let resp = api.get("/alliances/" & $allianceId, ifNoneMatch)
  result = newWarpyResponse[Alliance](resp)

proc getAllianceCorporations*(
  api: Warpy,
  allianceId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## List all current member corporations of an alliance.
  let resp = api.get("/alliances/" & $allianceId & "/corporations", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

proc getAllianceIcons*(
  api: Warpy,
  allianceId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[AllianceIcons] =
  ## Get the icon URLs for an alliance.
  let resp = api.get("/alliances/" & $allianceId & "/icons", ifNoneMatch)
  result = newWarpyResponse[AllianceIcons](resp)
