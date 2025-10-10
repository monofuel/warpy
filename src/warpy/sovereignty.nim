import
  std/[options],
  curly, jsony,
  ../core

type
  SovereigntyParticipant* = ref object
    allianceId*: int32       # Alliance ID.
    score*: float            # Score for this participant.

  SovereigntyCampaign* = ref object
    campaignId*: int32                         # Unique ID for this campaign.
    structureId*: int64                        # The structure item ID related to this campaign.
    solarSystemId*: int32                      # Solar system where the structure is located.
    constellationId*: int32                    # Constellation where the campaign takes place.
    eventType*: string                         # Type of event: tcu_defense, ihub_defense, station_defense, station_freeport.
    startTime*: string                         # Time the event is scheduled to start.
    defenderId*: Option[int32]                 # Defending alliance (only in Defense Events).
    defenderScore*: Option[float]              # Score for defending alliance (only in Defense Events).
    attackersScore*: Option[float]             # Score for attacking parties (only in Defense Events).
    participants*: Option[seq[SovereigntyParticipant]]  # Participants and scores (only in Freeport Events).

  SovereigntySystem* = ref object
    systemId*: int32                # System ID.
    allianceId*: Option[int32]      # Alliance that owns sovereignty.
    corporationId*: Option[int32]   # Corporation that owns sovereignty.
    factionId*: Option[int32]       # Faction that owns sovereignty.

  SovereigntyStructure* = ref object
    structureId*: int64                       # Unique item ID for this structure.
    allianceId*: int32                        # Alliance that owns the structure.
    solarSystemId*: int32                     # Solar system where structure is located.
    structureTypeId*: int32                   # Type of structure.
    vulnerabilityOccupancyLevel*: Option[float]  # Occupancy level (Activity Defense Multiplier).
    vulnerableStartTime*: Option[string]      # Start time of vulnerability window.
    vulnerableEndTime*: Option[string]        # End time of vulnerability window.

proc getSovereigntyCampaigns*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[SovereigntyCampaign]] =
  ## Shows sovereignty data for campaigns.
  let resp = api.get("/sovereignty/campaigns", ifNoneMatch)
  result = newWarpyResponse[seq[SovereigntyCampaign]](resp)

proc getSovereigntyMap*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[SovereigntySystem]] =
  ## Shows sovereignty information for solar systems.
  let resp = api.get("/sovereignty/map", ifNoneMatch)
  result = newWarpyResponse[seq[SovereigntySystem]](resp)

proc getSovereigntyStructures*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[SovereigntyStructure]] =
  ## Shows sovereignty data for structures.
  let resp = api.get("/sovereignty/structures", ifNoneMatch)
  result = newWarpyResponse[seq[SovereigntyStructure]](resp)

