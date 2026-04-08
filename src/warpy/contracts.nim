import
  std/[options],
  curly, jsony,
  ../core

type
  PublicContract* = ref object
    buyout*: Option[float64]              # Buyout price (for Auction type).
    collateral*: Option[float64]          # Collateral (for Courier type).
    contractId*: int32                    # Unique contract ID.
    dateExpired*: string                  # Expiry date.
    dateIssued*: string                   # Issue date.
    daysToComplete*: Option[int32]        # Days to complete (for Courier type).
    endLocationId*: Option[int64]         # End location ID.
    forCorporation*: Option[bool]         # Whether issued on behalf of a corporation.
    issuerCorporationId*: int32           # Issuer's corporation ID.
    issuerId*: int32                      # Issuer character ID.
    price*: Option[float64]              # Price of the contract.
    reward*: Option[float64]             # Reward for contract completion.
    startLocationId*: Option[int64]       # Start location ID.
    title*: Option[string]               # Contract title.
    `type`*: string                      # Contract type: unknown, item_exchange, auction, courier.
    volume*: Option[float64]             # Volume of items in the contract.

  PublicContractBid* = ref object
    amount*: float64                      # Bid amount.
    bidId*: int32                         # Unique bid ID.
    dateBid*: string                      # Date the bid was placed.

  PublicContractItem* = ref object
    isBlueprintCopy*: Option[bool]        # Whether the item is a blueprint copy.
    isIncluded*: bool                     # Whether the item is included in the contract.
    itemId*: Option[int64]               # Item ID.
    materialEfficiency*: Option[int32]    # Material efficiency (blueprints only).
    quantity*: int32                      # Number of items.
    recordId*: int32                      # Unique record ID.
    runs*: Option[int32]                 # Number of runs (blueprints only).
    timeEfficiency*: Option[int32]        # Time efficiency (blueprints only).
    typeId*: int32                        # Type ID of the item.

proc getPublicContracts*(
  api: Warpy,
  regionId: int32,
  page: int32 = 1,
  ifNoneMatch: string = ""
): WarpyResponse[seq[PublicContract]] =
  ## Get public contracts in a region.
  var url = "/contracts/public/" & $regionId
  if page > 1:
    url &= "?page=" & $page
  let resp = api.get(url, ifNoneMatch)
  result = newWarpyResponse[seq[PublicContract]](resp)

proc getPublicContractBids*(
  api: Warpy,
  contractId: int32,
  page: int32 = 1,
  ifNoneMatch: string = ""
): WarpyResponse[seq[PublicContractBid]] =
  ## Get bids on a public auction contract.
  var url = "/contracts/public/bids/" & $contractId
  if page > 1:
    url &= "?page=" & $page
  let resp = api.get(url, ifNoneMatch)
  result = newWarpyResponse[seq[PublicContractBid]](resp)

proc getPublicContractItems*(
  api: Warpy,
  contractId: int32,
  page: int32 = 1,
  ifNoneMatch: string = ""
): WarpyResponse[seq[PublicContractItem]] =
  ## Get items in a public contract.
  var url = "/contracts/public/items/" & $contractId
  if page > 1:
    url &= "?page=" & $page
  let resp = api.get(url, ifNoneMatch)
  result = newWarpyResponse[seq[PublicContractItem]](resp)
