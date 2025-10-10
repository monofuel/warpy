import
  std/[os, tables],
  jsony,
  ../src/types

const openApiPath = "openapi.json"

proc main() =
  if not fileExists(openApiPath):
    echo "Error: ", openApiPath, " not found"
    echo "Run 'nim c -r tools/fetch_openapi.nim' first"
    quit(1)

  echo "Reading OpenAPI spec from ", openApiPath
  let jsonContent = readFile(openApiPath)

  echo "Parsing OpenAPI spec..."
  let spec = jsonContent.fromJson(OpenApiSpec)

  echo "OpenAPI version: ", spec.openapi
  echo "Total paths: ", spec.paths.len

  var operationsByTag: Table[string, int]

  for path, pathItem in spec.paths:
    for op in [pathItem.get, pathItem.post, pathItem.put, pathItem.delete, pathItem.patch]:
      if op.operationId != "":
        for tag in op.tags:
          if tag notin operationsByTag:
            operationsByTag[tag] = 0
          operationsByTag[tag] += 1

  echo "\nOperations by tag:"
  for tag, count in operationsByTag.pairs:
    echo "  ", tag, ": ", count

when isMainModule:
  main()

