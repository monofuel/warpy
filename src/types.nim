import
  std/[tables, json],
  jsony

type
  ParameterOrRef* = object
    `$ref`*: string
    name*: string
    `in`*: string
    description*: string
    required*: bool
    schema*: JsonNode

  ResponseContent* = object
    description*: string
    content*: JsonNode
    headers*: JsonNode

  OpenApiSpec* = object
    openapi*: string
    info*: JsonNode
    servers*: JsonNode
    paths*: Table[string, PathItem]
    components*: JsonNode
    tags*: JsonNode

  PathItem* = object
    `get`*: Operation
    post*: Operation
    put*: Operation
    `delete`*: Operation
    patch*: Operation

  Operation* = object
    operationId*: string
    summary*: string
    description*: string
    tags*: seq[string]
    parameters*: seq[ParameterOrRef]
    requestBody*: JsonNode
    responses*: Table[string, ResponseContent]
    security*: JsonNode

