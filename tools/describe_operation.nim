import
  std/[os, strutils, json, tables, sequtils],
  jsony,
  ../src/types

const openApiPath = "openapi.json"

proc printUsage() =
  echo "Usage: describe_operation <METHOD> <PATH>"
  echo ""
  echo "Examples:"
  echo "  describe_operation GET /status"
  echo "  describe_operation GET /universe/systems/{system_id}"
  echo "  describe_operation POST /universe/ids"

proc main() =
  if paramCount() == 0:
    printUsage()
    quit(0)

  if paramCount() < 2:
    echo "Error: Missing required arguments"
    echo ""
    printUsage()
    quit(1)

  let httpMethod = paramStr(1).toUpper()
  let path = paramStr(2)

  if not fileExists(openApiPath):
    echo "Error: ", openApiPath, " not found"
    echo "Run 'nim c -r tools/fetch_openapi.nim' first"
    quit(1)

  let jsonContent = readFile(openApiPath)
  let spec = jsonContent.fromJson(OpenApiSpec)

  if not spec.paths.hasKey(path):
    echo "Error: Path '", path, "' not found in OpenAPI spec"
    quit(1)

  let pathItem = spec.paths.getOrDefault(path)

  # Find the operation for the specified method.
  var operation: Operation
  var found = false
  case httpMethod
  of "GET":
    if pathItem.`get`.operationId != "":
      operation = pathItem.`get`
      found = true
  of "POST":
    if pathItem.post.operationId != "":
      operation = pathItem.post
      found = true
  of "PUT":
    if pathItem.put.operationId != "":
      operation = pathItem.put
      found = true
  of "DELETE":
    if pathItem.`delete`.operationId != "":
      operation = pathItem.`delete`
      found = true
  of "PATCH":
    if pathItem.patch.operationId != "":
      operation = pathItem.patch
      found = true
  else:
    echo "Error: Unsupported HTTP method '", httpMethod, "'"
    quit(1)

  if not found:
    echo "Error: ", httpMethod, " operation not found for path '", path, "'"
    quit(1)

  # Display operation details in markdown format.
  echo "# ", httpMethod, " ", path
  echo ""
  echo "**Operation ID:** `", operation.operationId, "`"
  echo ""

  if operation.summary != "":
    echo "**Summary:** ", operation.summary
    echo ""

  if operation.description != "":
    echo operation.description
    echo ""

  if operation.tags.len > 0:
    echo "**Tags:** ", operation.tags.join(", ")
    echo ""

  # Parameters section.
  if operation.parameters.len > 0:
    echo "## Parameters"
    echo ""
    for param in operation.parameters:
      if param.`$ref` != "":
        # It's a reference.
        let refName = param.`$ref`.split("/")[^1]
        echo "- `", refName, "` (common parameter)"
      else:
        # It's an inline parameter definition.
        let reqStr = if param.required: " **(required)**" else: ""
        echo "- **", param.name, "** (`", param.`in`, "`)", reqStr
        if param.description != "":
          echo "  - ", param.description
        if not param.schema.isNil and param.schema.kind == JObject:
          if param.schema.hasKey("type"):
            echo "  - Type: `", param.schema["type"].getStr(), "`"
          if param.schema.hasKey("format"):
            echo "  - Format: `", param.schema["format"].getStr(), "`"
    echo ""

  # Request Body section.
  if not operation.requestBody.isNil and operation.requestBody.kind != JNull:
    echo "## Request Body"
    echo ""
    if operation.requestBody.kind == JObject:
      if operation.requestBody.hasKey("description"):
        echo operation.requestBody["description"].getStr()
        echo ""
      if operation.requestBody.hasKey("required"):
        if operation.requestBody["required"].getBool():
          echo "**(required)**"
          echo ""
    echo ""

  # Responses section.
  if operation.responses.len > 0:
    echo "## Responses"
    echo ""
    for statusCode, response in operation.responses:
      echo "### ", statusCode
      echo ""
      if response.description != "":
        echo response.description
        echo ""
    echo ""

  # Security section.
  if not operation.security.isNil and operation.security.kind != JNull:
    echo "## Security"
    echo ""
    if operation.security.kind == JArray:
      for secReq in operation.security.items:
        if secReq.kind == JObject:
          for secScheme, scopes in secReq.pairs:
            echo "- **", secScheme, "**"
            if scopes.kind == JArray and scopes.len > 0:
              echo "  - Scopes: `", scopes.elems.mapIt(it.getStr()).join("`, `"), "`"
    echo ""

when isMainModule:
  main()

