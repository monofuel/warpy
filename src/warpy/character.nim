import
  std/[options],
  curly, jsony,
  ../core

type
  CharacterPublicInfo* = ref object
    allianceId*: Option[int32]         # Alliance the character belongs to.
    birthday*: string                  # Character birthday.
    bloodlineId*: int32                # Bloodline ID.
    corporationId*: int32              # Corporation ID.
    description*: Option[string]       # Character description.
    factionId*: Option[int32]          # Faction ID if in faction warfare.
    gender*: string                    # Gender: male or female.
    name*: string                      # Character name.
    raceId*: int32                     # Race ID.
    securityStatus*: Option[float]     # Security status.
    title*: Option[string]             # Character title.

  CharacterAffiliation* = ref object
    allianceId*: Option[int32]         # Alliance the character belongs to.
    characterId*: int32                # Character ID.
    corporationId*: int32              # Corporation ID.
    factionId*: Option[int32]          # Faction ID if in faction warfare.

  CharacterCorporationHistory* = ref object
    corporationId*: int32              # Corporation ID.
    isDeleted*: Option[bool]           # True if the corporation was closed.
    recordId*: int32                   # Unique record ID.
    startDate*: string                 # Date the character joined.

  CharacterPortrait* = ref object
    px64x64*: Option[string]           # 64x64 portrait URL.
    px128x128*: Option[string]         # 128x128 portrait URL.
    px256x256*: Option[string]         # 256x256 portrait URL.
    px512x512*: Option[string]         # 512x512 portrait URL.

proc getCharacter*(
  api: Warpy,
  characterId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[CharacterPublicInfo] =
  ## Get public information about a character.
  let resp = api.get("/characters/" & $characterId, ifNoneMatch)
  result = newWarpyResponse[CharacterPublicInfo](resp)

proc postCharacterAffiliation*(
  api: Warpy,
  characterIds: seq[int32]
): WarpyResponse[seq[CharacterAffiliation]] =
  ## Bulk lookup of character corporation, alliance, and faction IDs.
  assert characterIds.len > 0
  assert characterIds.len <= 1000
  let resp = api.post("/characters/affiliation", toJson(characterIds))
  result = newWarpyResponse[seq[CharacterAffiliation]](resp)

proc getCharacterCorporationHistory*(
  api: Warpy,
  characterId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[seq[CharacterCorporationHistory]] =
  ## Get a character's corporation history.
  let resp = api.get("/characters/" & $characterId & "/corporationhistory", ifNoneMatch)
  result = newWarpyResponse[seq[CharacterCorporationHistory]](resp)

proc getCharacterPortrait*(
  api: Warpy,
  characterId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[CharacterPortrait] =
  ## Get portrait URLs for a character.
  let resp = api.get("/characters/" & $characterId & "/portrait", ifNoneMatch)
  result = newWarpyResponse[CharacterPortrait](resp)
