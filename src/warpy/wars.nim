import
  std/[options],
  curly, jsony,
  ../core

type
  WarParticipant* = ref object
    allianceId*: Option[int32]       # Alliance ID if the participant is an alliance.
    corporationId*: Option[int32]    # Corporation ID if the participant is a corporation.
    iskDestroyed*: float             # ISK value of ships destroyed.
    shipsKilled*: int32              # Number of ships killed.

  WarAlly* = ref object
    allianceId*: Option[int32]       # Alliance ID if ally is an alliance.
    corporationId*: Option[int32]    # Corporation ID if ally is a corporation.

  War* = ref object
    id*: int32                       # ID of the war.
    declared*: string                # Time that the war was declared.
    started*: Option[string]         # Time when the war started and both sides could shoot each other.
    finished*: Option[string]        # Time the war ended and shooting was no longer allowed.
    retracted*: Option[string]       # Time the war was retracted but both sides could still shoot each other.
    mutual*: bool                    # Was the war declared mutual by both parties.
    openForAllies*: bool             # Is the war currently open for allies or not.
    aggressor*: WarParticipant       # The aggressor corporation or alliance that declared this war.
    defender*: WarParticipant        # The defending corporation or alliance.
    allies*: Option[seq[WarAlly]]    # Allied corporations or alliances.

  WarKillmail* = ref object
    killmailId*: int32               # ID of this killmail.
    killmailHash*: string            # A hash of this killmail.

proc getWars*(
  api: Warpy,
  maxWarId: int32 = 0,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## Return a list of wars.
  var url = "/wars"
  if maxWarId > 0:
    url &= "?max_war_id=" & $maxWarId
  let resp = api.get(url, ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

proc getWar*(
  api: Warpy,
  warId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[War] =
  ## Return details about a war.
  let resp = api.get("/wars/" & $warId, ifNoneMatch)
  result = newWarpyResponse[War](resp)

proc getWarKillmails*(
  api: Warpy,
  warId: int32,
  page: int32 = 1,
  ifNoneMatch: string = ""
): WarpyResponse[seq[WarKillmail]] =
  ## Return a list of kills related to a war.
  var url = "/wars/" & $warId & "/killmails"
  if page > 1:
    url &= "?page=" & $page
  let resp = api.get(url, ifNoneMatch)
  result = newWarpyResponse[seq[WarKillmail]](resp)

