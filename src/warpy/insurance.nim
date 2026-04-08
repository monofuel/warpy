import
  std/[options],
  curly, jsony,
  ../core

type
  InsuranceLevel* = ref object
    cost*: float             # Cost of this insurance level.
    name*: string            # Localized name of the insurance level.
    payout*: float           # Payout amount for this level.

  InsurancePrice* = ref object
    levels*: seq[InsuranceLevel]  # Available insurance levels for this type.
    typeId*: int32                # Type ID of the ship.

proc getInsurancePrices*(
  api: Warpy,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[seq[InsurancePrice]] =
  ## Return available insurance levels for all ship types.
  let resp = api.get("/insurance/prices?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[seq[InsurancePrice]](resp)
