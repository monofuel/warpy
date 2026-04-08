import
  std/[options],
  curly, jsony,
  ../core

type
  KillmailItem* = ref object
    flag*: int32                         # Item flag (slot/location).
    itemTypeId*: int32                   # Type ID of the item.
    items*: Option[seq[KillmailItem]]    # Nested items (e.g. items in a container).
    quantityDestroyed*: Option[int64]    # Quantity destroyed.
    quantityDropped*: Option[int64]      # Quantity dropped.
    singleton*: int32                    # Singleton flag.

  KillmailAttacker* = ref object
    allianceId*: Option[int32]           # Attacker's alliance ID.
    characterId*: Option[int32]          # Attacker's character ID.
    corporationId*: Option[int32]        # Attacker's corporation ID.
    damageDone*: int32                   # Damage dealt by attacker.
    factionId*: Option[int32]            # Attacker's faction ID.
    finalBlow*: bool                     # Whether this attacker got the final blow.
    securityStatus*: float               # Attacker's security status.
    shipTypeId*: Option[int32]           # Ship the attacker was flying.
    weaponTypeId*: Option[int32]         # Weapon used.

  KillmailVictim* = ref object
    allianceId*: Option[int32]           # Victim's alliance ID.
    characterId*: Option[int32]          # Victim's character ID.
    corporationId*: Option[int32]        # Victim's corporation ID.
    damageTaken*: int32                  # Total damage taken.
    factionId*: Option[int32]            # Victim's faction ID.
    items*: Option[seq[KillmailItem]]    # Items on the victim's ship.
    position*: Option[EsiPosition]       # Position where the kill happened.
    shipTypeId*: int32                   # Ship type the victim was flying.

  Killmail* = ref object
    attackers*: seq[KillmailAttacker]    # List of attackers.
    killmailId*: int32                   # Killmail ID.
    killmailTime*: string               # Time of the kill.
    moonId*: Option[int32]              # Moon ID if kill was near a moon.
    solarSystemId*: int32                # Solar system of the kill.
    victim*: KillmailVictim              # Victim information.
    warId*: Option[int32]               # War ID if part of a war.

proc getKillmail*(
  api: Warpy,
  killmailId: int32,
  killmailHash: string,
  ifNoneMatch: string = ""
): WarpyResponse[Killmail] =
  ## Get a single killmail by ID and hash.
  let resp = api.get("/killmails/" & $killmailId & "/" & killmailHash, ifNoneMatch)
  result = newWarpyResponse[Killmail](resp)
