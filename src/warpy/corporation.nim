import
  std/[options],
  curly, jsony,
  ../core

type
  Corporation* = ref object
    allianceId*: Option[int32]         # Alliance the corporation belongs to, if any.
    ceoId*: int32                      # CEO character ID.
    creatorId*: int32                  # Creator character ID.
    dateFounded*: Option[string]       # Date the corporation was founded.
    description*: Option[string]       # Corporation description.
    factionId*: Option[int32]          # Faction ID if in faction warfare.
    homeStationId*: Option[int32]      # Home station ID.
    memberCount*: int32                # Number of members.
    name*: string                      # Corporation name.
    shares*: Option[int64]             # Number of shares.
    taxRate*: float                    # Tax rate (0.0 to 1.0).
    ticker*: string                    # Corporation ticker.
    url*: Option[string]              # URL if set.
    warEligible*: Option[bool]         # Whether the corporation is war eligible.

  CorporationAllianceHistory* = ref object
    allianceId*: Option[int32]         # Alliance ID (absent if corp left alliance).
    isDeleted*: Option[bool]           # True if the alliance was closed.
    recordId*: int32                   # Unique record ID.
    startDate*: string                 # Date the corp joined or left.

  CorporationIcons* = ref object
    px64x64*: Option[string]           # 64x64 icon URL.
    px128x128*: Option[string]         # 128x128 icon URL.
    px256x256*: Option[string]         # 256x256 icon URL.

proc getCorporation*(
  api: Warpy,
  corporationId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[Corporation] =
  ## Get public information about a corporation.
  let resp = api.get("/corporations/" & $corporationId, ifNoneMatch)
  result = newWarpyResponse[Corporation](resp)

proc getNpcCorps*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## Get a list of NPC corporation IDs.
  let resp = api.get("/corporations/npccorps", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

proc getCorporationAllianceHistory*(
  api: Warpy,
  corporationId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[seq[CorporationAllianceHistory]] =
  ## Get the alliance history of a corporation.
  let resp = api.get("/corporations/" & $corporationId & "/alliancehistory", ifNoneMatch)
  result = newWarpyResponse[seq[CorporationAllianceHistory]](resp)

proc getCorporationIcons*(
  api: Warpy,
  corporationId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[CorporationIcons] =
  ## Get the icon URLs for a corporation.
  let resp = api.get("/corporations/" & $corporationId & "/icons", ifNoneMatch)
  result = newWarpyResponse[CorporationIcons](resp)
