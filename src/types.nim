import
  std/[tables, json],
  jsony

type
  OpenApiSpec* = object
    openapi*: string
    info*: JsonNode
    servers*: JsonNode
    paths*: Table[string, PathItem]
    components*: JsonNode
    tags*: JsonNode

  PathItem* = object
    get*: Operation
    post*: Operation
    put*: Operation
    delete*: Operation
    patch*: Operation

  Operation* = object
    operationId*: string
    summary*: string
    description*: string
    tags*: seq[string]
    parameters*: JsonNode
    requestBody*: JsonNode
    responses*: JsonNode
    security*: JsonNode

