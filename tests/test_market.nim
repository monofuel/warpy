import
  std/[unittest, options],
  warpy

suite "Market":
  var api: Warpy
  setup:
    api = newWarpy()

  test "/markets/groups":
    let resp = api.getMarketGroups()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/markets/groups/{market_group_id}":
    # Test with market group ID 4 (Ships).
    let resp = api.getMarketGroup(4)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.marketGroupId == 4
    assert resp.body.get.name != ""  # Just verify we got a name.

  test "/markets/prices":
    let resp = api.getMarketPrices()
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # Verify we have price data.
    var foundPrice = false
    for price in resp.body.get:
      if price.typeId > 0:
        foundPrice = true
        break
    assert foundPrice

  test "/markets/{region_id}/types":
    # Get market types in The Forge (10000002).
    let resp = api.getMarketTypes(10000002)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0

  test "/markets/{region_id}/orders - all":
    # Get all orders in The Forge for Tritanium (34).
    let resp = api.getMarketOrders(regionId = 10000002, typeId = 34)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # Verify we have valid order data.
    for order in resp.body.get:
      assert order.orderId > 0
      assert order.typeId == 34
      assert order.price > 0

  test "/markets/{region_id}/orders - buy orders":
    # Get buy orders in The Forge for Tritanium (34).
    let resp = api.getMarketOrders(regionId = 10000002, orderType = buy, typeId = 34)
    assert resp.code == 200
    assert resp.body.isSome
    # All orders should be buy orders.
    for order in resp.body.get:
      assert order.isBuyOrder == true

  test "/markets/{region_id}/orders - sell orders":
    # Get sell orders in The Forge for Tritanium (34).
    let resp = api.getMarketOrders(regionId = 10000002, orderType = sell, typeId = 34)
    assert resp.code == 200
    assert resp.body.isSome
    # All orders should be sell orders.
    for order in resp.body.get:
      assert order.isBuyOrder == false

  test "/markets/{region_id}/history":
    # Get market history for Tritanium (34) in The Forge (10000002).
    let resp = api.getMarketHistory(regionId = 10000002, typeId = 34)
    assert resp.code == 200
    assert resp.body.isSome
    assert resp.body.get.len > 0
    # Verify we have valid history data.
    for entry in resp.body.get:
      assert entry.date != ""
      assert entry.orderCount >= 0
      assert entry.volume >= 0

