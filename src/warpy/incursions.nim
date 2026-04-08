import
  std/[options],
  curly, jsony,
  ../core

type
  Incursion* = ref object
    constellationId*: int32              # Constellation where the incursion is staged.
    factionId*: int32                    # The attacking faction's ID.
    hasBoss*: bool                       # Whether the boss spawn is live.
    infestedSolarSystems*: seq[int32]    # List of infested solar system IDs.
    influence*: float                    # Influence of the incursion (0.0 to 1.0).
    stagingSolarSystemId*: int32         # Staging solar system for the incursion.
    state*: string                       # State of the incursion: withdrawing, mobilizing, established.
    `type`*: string                      # Type of incursion: Scout, Vanguard, Assault, Headquarters, Mothership.

proc getIncursions*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[Incursion]] =
  ## Return a list of current incursions.
  let resp = api.get("/incursions", ifNoneMatch)
  result = newWarpyResponse[seq[Incursion]](resp)
