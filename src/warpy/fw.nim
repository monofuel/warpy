import
  std/[options],
  curly, jsony,
  ../core

type
  FwKills* = ref object
    lastWeek*: int32                     # Kills last week.
    total*: int32                        # Total kills.
    yesterday*: int32                    # Kills yesterday.

  FwVictoryPoints* = ref object
    lastWeek*: int32                     # Victory points last week.
    total*: int32                        # Total victory points.
    yesterday*: int32                    # Victory points yesterday.

  FwFactionStat* = ref object
    factionId*: int32                    # Faction ID.
    kills*: FwKills                      # Kill statistics.
    pilots*: int32                       # Number of pilots in faction warfare.
    systemsControlled*: int32            # Number of systems controlled.
    victoryPoints*: FwVictoryPoints      # Victory point statistics.

  FwLeaderboardEntry* = ref object
    amount*: Option[int32]               # Amount of kills or victory points.
    factionId*: Option[int32]            # Faction ID.

  FwLeaderboardCategory* = ref object
    activeTotal*: seq[FwLeaderboardEntry]   # All-time leaders.
    lastWeek*: seq[FwLeaderboardEntry]      # Last week leaders.
    yesterday*: seq[FwLeaderboardEntry]     # Yesterday leaders.

  FwLeaderboards* = ref object
    kills*: FwLeaderboardCategory        # Kill leaderboard.
    victoryPoints*: FwLeaderboardCategory # Victory points leaderboard.

  FwCharacterLeaderboardEntry* = ref object
    amount*: Option[int32]               # Amount of kills or victory points.
    characterId*: Option[int32]          # Character ID.

  FwCharacterLeaderboardCategory* = ref object
    activeTotal*: seq[FwCharacterLeaderboardEntry]
    lastWeek*: seq[FwCharacterLeaderboardEntry]
    yesterday*: seq[FwCharacterLeaderboardEntry]

  FwCharacterLeaderboards* = ref object
    kills*: FwCharacterLeaderboardCategory
    victoryPoints*: FwCharacterLeaderboardCategory

  FwCorporationLeaderboardEntry* = ref object
    amount*: Option[int32]               # Amount of kills or victory points.
    corporationId*: Option[int32]        # Corporation ID.

  FwCorporationLeaderboardCategory* = ref object
    activeTotal*: seq[FwCorporationLeaderboardEntry]
    lastWeek*: seq[FwCorporationLeaderboardEntry]
    yesterday*: seq[FwCorporationLeaderboardEntry]

  FwCorporationLeaderboards* = ref object
    kills*: FwCorporationLeaderboardCategory
    victoryPoints*: FwCorporationLeaderboardCategory

  FwSystem* = ref object
    contested*: string                   # Status: captured, contested, uncontested, vulnerable.
    occupierFactionId*: int32            # Occupying faction ID.
    ownerFactionId*: int32               # Owning faction ID.
    solarSystemId*: int32                # Solar system ID.
    victoryPoints*: int32                # Current victory points.
    victoryPointsThreshold*: int32       # Victory points needed.

  FwWar* = ref object
    againstId*: int32                    # Opposing faction ID.
    factionId*: int32                    # Faction ID.

proc getFwStats*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[FwFactionStat]] =
  ## Get faction warfare statistics for all factions.
  let resp = api.get("/fw/stats", ifNoneMatch)
  result = newWarpyResponse[seq[FwFactionStat]](resp)

proc getFwLeaderboards*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[FwLeaderboards] =
  ## Get the top factions in faction warfare.
  let resp = api.get("/fw/leaderboards", ifNoneMatch)
  result = newWarpyResponse[FwLeaderboards](resp)

proc getFwCharacterLeaderboards*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[FwCharacterLeaderboards] =
  ## Get the top characters in faction warfare.
  let resp = api.get("/fw/leaderboards/characters", ifNoneMatch)
  result = newWarpyResponse[FwCharacterLeaderboards](resp)

proc getFwCorporationLeaderboards*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[FwCorporationLeaderboards] =
  ## Get the top corporations in faction warfare.
  let resp = api.get("/fw/leaderboards/corporations", ifNoneMatch)
  result = newWarpyResponse[FwCorporationLeaderboards](resp)

proc getFwSystems*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[FwSystem]] =
  ## Get faction warfare systems and ownership.
  let resp = api.get("/fw/systems", ifNoneMatch)
  result = newWarpyResponse[seq[FwSystem]](resp)

proc getFwWars*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[FwWar]] =
  ## Get faction warfare wars.
  let resp = api.get("/fw/wars", ifNoneMatch)
  result = newWarpyResponse[seq[FwWar]](resp)
