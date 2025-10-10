import
  std/[os, tables, sets, strutils, algorithm, parseopt],
  jsony,
  ../src/[types, mapping]

const openApiPath = "openapi.json"

proc printUsage() =
  echo "Usage: check_coverage [options]"
  echo ""
  echo "Options:"
  echo "  --list-missing    List all unimplemented operations"
  echo "  --help            Show this help message"

proc main() =
  var listMissing = false

  # Parse command-line arguments.
  var p = initOptParser()
  for kind, key, val in p.getopt():
    case kind
    of cmdLongOption:
      case key
      of "list-missing":
        listMissing = true
      of "help":
        printUsage()
        quit(0)
      else:
        echo "Unknown option: --", key
        printUsage()
        quit(1)
    of cmdShortOption:
      echo "Unknown option: -", key
      printUsage()
      quit(1)
    of cmdArgument:
      echo "Unexpected argument: ", key
      printUsage()
      quit(1)
    of cmdEnd:
      discard

  if not fileExists(openApiPath):
    echo "Error: ", openApiPath, " not found"
    echo "Run 'nim c -r tools/fetch_openapi.nim' first"
    quit(1)

  echo "Reading OpenAPI spec from ", openApiPath
  let jsonContent = readFile(openApiPath)

  echo "Parsing OpenAPI spec..."
  let spec = jsonContent.fromJson(OpenApiSpec)

  # Build a set of implemented operations from our mapping.
  var implementedOps: HashSet[string]
  for m in apiMappings:
    let key = m.httpMethod.toUpper() & " " & m.path
    implementedOps.incl(key)

  # Count total operations and implemented ones.
  var totalOps = 0
  var operationsByTag: Table[string, int]
  var implementedByTag: Table[string, int]
  var unimplementedOps: seq[tuple[tag: string, httpMethod: string, path: string, operationId: string]]

  for path, pathItem in spec.paths:
    for (methodName, op) in [("GET", pathItem.`get`), ("POST", pathItem.post),
                              ("PUT", pathItem.put), ("DELETE", pathItem.`delete`),
                              ("PATCH", pathItem.patch)]:
      if op.operationId != "":
        totalOps += 1
        let key = methodName & " " & path
        let isImplemented = key in implementedOps

        for tag in op.tags:
          if tag notin operationsByTag:
            operationsByTag[tag] = 0
            implementedByTag[tag] = 0
          operationsByTag[tag] += 1
          if isImplemented:
            implementedByTag[tag] += 1
          else:
            unimplementedOps.add((tag: tag, httpMethod: methodName, path: path, operationId: op.operationId))

  echo "\nImplementation Status:"
  echo "  Total operations in API: ", totalOps
  echo "  Implemented operations: ", implementedOps.len
  echo "  Coverage: ", (implementedOps.len.float / totalOps.float * 100.0).formatFloat(ffDecimal, 1), "%"

  echo "\nOperations by tag (implemented/total):"
  var tagList: seq[string]
  for tag in operationsByTag.keys:
    tagList.add(tag)
  tagList.sort()

  for tag in tagList:
    let total = operationsByTag[tag]
    let implemented = implementedByTag[tag]
    echo "  ", tag.alignLeft(25), ": ", ($implemented).align(3), " / ", ($total).align(3)

  echo "\n" & $unimplementedOps.len & " unimplemented operations"

  if listMissing:
    echo "\nUnimplemented operations by tag:"
    var opsByTag: Table[string, seq[tuple[httpMethod: string, path: string, operationId: string]]]
    for op in unimplementedOps:
      if op.tag notin opsByTag:
        opsByTag[op.tag] = @[]
      opsByTag[op.tag].add((httpMethod: op.httpMethod, path: op.path, operationId: op.operationId))

    for tag in tagList:
      if tag in opsByTag:
        echo "\n  ", tag, ":"
        for op in opsByTag[tag]:
          echo "    ", op.httpMethod.alignLeft(6), " ", op.path.alignLeft(50), " (", op.operationId, ")"

when isMainModule:
  main()

