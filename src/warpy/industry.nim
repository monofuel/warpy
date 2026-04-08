import
  std/[options],
  curly, jsony,
  ../core

type
  IndustryFacility* = ref object
    facilityId*: int64          # Facility ID.
    ownerId*: int32             # Owner of the facility.
    regionId*: int32            # Region where the facility is located.
    solarSystemId*: int32       # Solar system where the facility is located.
    tax*: Option[float]         # Tax imposed on the facility.
    typeId*: int32              # Type ID of the facility.

  IndustryCostIndex* = ref object
    activity*: string           # Activity type (manufacturing, researching_time_efficiency, etc).
    costIndex*: float           # Cost index for this activity.

  IndustrySystem* = ref object
    costIndices*: seq[IndustryCostIndex]  # Cost indices for activities in this system.
    solarSystemId*: int32                 # Solar system ID.

proc getIndustryFacilities*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[IndustryFacility]] =
  ## Return a list of industry facilities.
  let resp = api.get("/industry/facilities", ifNoneMatch)
  result = newWarpyResponse[seq[IndustryFacility]](resp)

proc getIndustrySystems*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[IndustrySystem]] =
  ## Return cost indices for solar systems.
  let resp = api.get("/industry/systems", ifNoneMatch)
  result = newWarpyResponse[seq[IndustrySystem]](resp)
