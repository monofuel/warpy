import
  std/[os],
  curly

const openApiUrl = "https://esi.evetech.net/meta/openapi.json"
const outputPath = "openapi.json"

proc main() =
  echo "Fetching OpenAPI spec from ", openApiUrl

  let curl = newCurly()
  let response = curl.get(openApiUrl)

  if response.code != 200:
    echo "Error: HTTP ", response.code
    quit(1)

  writeFile(outputPath, response.body)

  echo "OpenAPI spec saved to ", outputPath
  echo "File size: ", getFileSize(outputPath), " bytes"

when isMainModule:
  main()

