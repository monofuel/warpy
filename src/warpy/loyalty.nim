import
  std/[options],
  curly, jsony,
  ../core

type
  LoyaltyRequiredItem* = ref object
    quantity*: int32                      # Quantity of the item required.
    typeId*: int32                        # Type ID of the required item.

  LoyaltyOffer* = ref object
    akCost*: Option[int32]               # Analysis kredit cost.
    iskCost*: int64                       # ISK cost.
    lpCost*: int32                        # Loyalty point cost.
    offerId*: int32                       # Offer ID.
    quantity*: int32                      # Quantity of items received.
    requiredItems*: seq[LoyaltyRequiredItem]  # Required items to exchange.
    typeId*: int32                        # Type ID of the item offered.

proc getLoyaltyOffers*(
  api: Warpy,
  corporationId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[seq[LoyaltyOffer]] =
  ## Get loyalty point offers for a corporation.
  let resp = api.get("/loyalty/stores/" & $corporationId & "/offers", ifNoneMatch)
  result = newWarpyResponse[seq[LoyaltyOffer]](resp)
