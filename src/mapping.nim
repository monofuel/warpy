## Mapping between ESI API operations and Warpy Nim procs.
## This allows us to track which operations are implemented and which are not.

type
  ApiMapping* = object
    httpMethod*: string  # HTTP method: GET, POST, PUT, DELETE, PATCH.
    path*: string        # API path from OpenAPI spec.
    nimProc*: string     # The Nim proc name that implements this operation.

const apiMappings*: seq[ApiMapping] = @[
  # Status
  ApiMapping(httpMethod: "GET", path: "/status", nimProc: "getStatus"),

  # Universe - Ancestries
  ApiMapping(httpMethod: "GET", path: "/universe/ancestries", nimProc: "getAncestries"),

  # Universe - Asteroid Belts
  ApiMapping(httpMethod: "GET", path: "/universe/asteroid_belts/{asteroid_belt_id}", nimProc: "getAsteroidBelts"),

  # Universe - Bloodlines
  ApiMapping(httpMethod: "GET", path: "/universe/bloodlines", nimProc: "getBloodlines"),

  # Universe - Categories
  ApiMapping(httpMethod: "GET", path: "/universe/categories", nimProc: "getItemCategories"),
  ApiMapping(httpMethod: "GET", path: "/universe/categories/{category_id}", nimProc: "getItemCategory"),

  # Universe - Constellations
  ApiMapping(httpMethod: "GET", path: "/universe/constellations", nimProc: "getConstellations"),
  ApiMapping(httpMethod: "GET", path: "/universe/constellations/{constellation_id}", nimProc: "getConstellation"),

  # Universe - Factions
  ApiMapping(httpMethod: "GET", path: "/universe/factions", nimProc: "getFactions"),

  # Universe - Graphics
  ApiMapping(httpMethod: "GET", path: "/universe/graphics", nimProc: "getGraphics"),
  ApiMapping(httpMethod: "GET", path: "/universe/graphics/{graphic_id}", nimProc: "getGraphic"),

  # Universe - Groups
  ApiMapping(httpMethod: "GET", path: "/universe/groups", nimProc: "getGroups"),
  ApiMapping(httpMethod: "GET", path: "/universe/groups/{group_id}", nimProc: "getGroup"),

  # Universe - IDs
  ApiMapping(httpMethod: "POST", path: "/universe/ids", nimProc: "bulkNamesToIds"),

  # Universe - Moons
  ApiMapping(httpMethod: "GET", path: "/universe/moons/{moon_id}", nimProc: "getMoon"),

  # Universe - Names
  ApiMapping(httpMethod: "POST", path: "/universe/names", nimProc: "bulkIdsToNames"),

  # Universe - Planets
  ApiMapping(httpMethod: "GET", path: "/universe/planets/{planet_id}", nimProc: "getPlanet"),

  # Universe - Races
  ApiMapping(httpMethod: "GET", path: "/universe/races", nimProc: "getRaces"),

  # Universe - Regions
  ApiMapping(httpMethod: "GET", path: "/universe/regions", nimProc: "getRegions"),
  ApiMapping(httpMethod: "GET", path: "/universe/regions/{region_id}", nimProc: "getRegion"),

  # Universe - Stargates
  ApiMapping(httpMethod: "GET", path: "/universe/stargates/{stargate_id}", nimProc: "getStargate"),

  # Universe - Stars
  ApiMapping(httpMethod: "GET", path: "/universe/stars/{star_id}", nimProc: "getStar"),

  # Universe - Stations
  ApiMapping(httpMethod: "GET", path: "/universe/stations/{station_id}", nimProc: "getStation"),

  # Universe - Structures
  ApiMapping(httpMethod: "GET", path: "/universe/structures", nimProc: "getStructures"),
  ApiMapping(httpMethod: "GET", path: "/universe/structures/{structure_id}", nimProc: "getStructure"),

  # Universe - System Jumps
  ApiMapping(httpMethod: "GET", path: "/universe/system_jumps", nimProc: "getSystemJumps"),

  # Universe - System Kills
  ApiMapping(httpMethod: "GET", path: "/universe/system_kills", nimProc: "getSystemKills"),

  # Universe - Systems
  ApiMapping(httpMethod: "GET", path: "/universe/systems", nimProc: "getSystems"),
  ApiMapping(httpMethod: "GET", path: "/universe/systems/{system_id}", nimProc: "getSystem"),

  # Universe - Types
  ApiMapping(httpMethod: "GET", path: "/universe/types", nimProc: "getTypes"),
  ApiMapping(httpMethod: "GET", path: "/universe/types/{type_id}", nimProc: "getType"),

  # Wars
  ApiMapping(httpMethod: "GET", path: "/wars", nimProc: "getWars"),
  ApiMapping(httpMethod: "GET", path: "/wars/{war_id}", nimProc: "getWar"),
  ApiMapping(httpMethod: "GET", path: "/wars/{war_id}/killmails", nimProc: "getWarKillmails"),

  # Sovereignty
  ApiMapping(httpMethod: "GET", path: "/sovereignty/campaigns", nimProc: "getSovereigntyCampaigns"),
  ApiMapping(httpMethod: "GET", path: "/sovereignty/map", nimProc: "getSovereigntyMap"),
  ApiMapping(httpMethod: "GET", path: "/sovereignty/structures", nimProc: "getSovereigntyStructures"),

  # Routes
  ApiMapping(httpMethod: "GET", path: "/route/{origin}/{destination}", nimProc: "getRoute"),

  # Meta
  ApiMapping(httpMethod: "GET", path: "/meta/changelog", nimProc: "getChangelog"),
  ApiMapping(httpMethod: "GET", path: "/meta/compatibility-dates", nimProc: "getCompatibilityDates"),

  # Planetary Interaction
  ApiMapping(httpMethod: "GET", path: "/universe/schematics/{schematic_id}", nimProc: "getSchematic"),

  # Market
  ApiMapping(httpMethod: "GET", path: "/markets/groups", nimProc: "getMarketGroups"),
  ApiMapping(httpMethod: "GET", path: "/markets/groups/{market_group_id}", nimProc: "getMarketGroup"),
  ApiMapping(httpMethod: "GET", path: "/markets/prices", nimProc: "getMarketPrices"),
  ApiMapping(httpMethod: "GET", path: "/markets/{region_id}/types", nimProc: "getMarketTypes"),
  ApiMapping(httpMethod: "GET", path: "/markets/{region_id}/orders", nimProc: "getMarketOrders"),
  ApiMapping(httpMethod: "GET", path: "/markets/{region_id}/history", nimProc: "getMarketHistory"),
]

