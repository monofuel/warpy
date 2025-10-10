import
  std/[options, strformat],
  curly, jsony,
  ../core

type
  MarketGroup* = ref object
    marketGroupId*: int32      # Market group ID.
    name*: string              # Name of the market group.
    description*: string       # Description of the market group.
    types*: seq[int32]         # Types in this market group.
    parentGroupId*: Option[int32]  # Parent market group ID (if any).

  MarketPrice* = ref object
    typeId*: int32             # Type ID.
    adjustedPrice*: Option[float]   # Adjusted price (used for industry).
    averagePrice*: Option[float]    # Average price.

  MarketOrder* = ref object
    orderId*: int64            # Unique order ID.
    typeId*: int32             # Type ID being traded.
    locationId*: int64         # Location ID (station/structure).
    systemId*: int32           # Solar system ID where order is placed.
    volumeTotal*: int32        # Total volume for this order.
    volumeRemain*: int32       # Volume remaining.
    minVolume*: int32          # Minimum volume to fill.
    price*: float              # Price per unit.
    isBuyOrder*: bool          # Whether this is a buy order.
    duration*: int32           # Duration of the order in days.
    issued*: string            # When the order was issued.
    range*: string             # Valid order range (station, region, solarsystem, 1-40).

  MarketHistory* = ref object
    date*: string              # Date of this historical statistic.
    orderCount*: int64         # Total number of orders that day.
    volume*: int64             # Total volume traded.
    highest*: float            # Highest price.
    average*: float            # Average price.
    lowest*: float             # Lowest price.

  OrderType* = enum
    ## Market order type filter.
    all,     # All orders.
    buy,     # Buy orders only.
    sell     # Sell orders only.

proc getMarketGroups*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## Get a list of item groups.
  let resp = api.get("/markets/groups", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

proc getMarketGroup*(
  api: Warpy,
  marketGroupId: int32,
  language: EsiLanguage = en,
  ifNoneMatch: string = ""
): WarpyResponse[MarketGroup] =
  ## Get information on an item group.
  let resp = api.get("/markets/groups/" & $marketGroupId & "?language=" & $language, ifNoneMatch)
  result = newWarpyResponse[MarketGroup](resp)

proc getMarketPrices*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[MarketPrice]] =
  ## Return a list of prices.
  let resp = api.get("/markets/prices", ifNoneMatch)
  result = newWarpyResponse[seq[MarketPrice]](resp)

proc getMarketTypes*(
  api: Warpy,
  regionId: int32,
  page: int32 = 1,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## Return a list of type IDs that have active orders in the region.
  let resp = api.get(&"/markets/{regionId}/types?page={page}", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

proc getMarketOrders*(
  api: Warpy,
  regionId: int32,
  orderType: OrderType = all,
  typeId: int32 = 0,
  page: int32 = 1,
  ifNoneMatch: string = ""
): WarpyResponse[seq[MarketOrder]] =
  ## Return a list of orders in a region.
  var url = &"/markets/{regionId}/orders?order_type={orderType}&page={page}"
  if typeId > 0:
    url &= &"&type_id={typeId}"
  let resp = api.get(url, ifNoneMatch)
  result = newWarpyResponse[seq[MarketOrder]](resp)

proc getMarketHistory*(
  api: Warpy,
  regionId: int32,
  typeId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[seq[MarketHistory]] =
  ## Return a list of historical market statistics for the specified type in a region.
  let resp = api.get(&"/markets/{regionId}/history?type_id={typeId}", ifNoneMatch)
  result = newWarpyResponse[seq[MarketHistory]](resp)

