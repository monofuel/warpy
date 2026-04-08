import
  std/[options],
  curly, jsony,
  ../core

type
  DogmaAttribute* = ref object
    attributeId*: int32                  # Attribute ID.
    defaultValue*: Option[float]         # Default value.
    description*: Option[string]         # Description.
    displayName*: Option[string]         # Display name.
    highIsGood*: Option[bool]            # Whether a higher value is better.
    iconId*: Option[int32]               # Icon ID.
    name*: Option[string]               # Attribute name.
    published*: Option[bool]             # Whether the attribute is published.
    stackable*: Option[bool]             # Whether the attribute is stackable.
    unitId*: Option[int32]               # Unit ID.

  DogmaEffectModifier* = ref object
    domain*: Option[string]              # Domain of the modifier.
    effectId*: Option[int32]             # Effect ID.
    `func`*: string                      # Modifier function.
    modifiedAttributeId*: Option[int32]  # Attribute being modified.
    modifyingAttributeId*: Option[int32] # Attribute doing the modifying.
    operator*: Option[int32]             # Operator applied.

  DogmaEffect* = ref object
    description*: Option[string]         # Description.
    disallowAutoRepeat*: Option[bool]    # Whether auto-repeat is disallowed.
    dischargeAttributeId*: Option[int32] # Discharge attribute ID.
    displayName*: Option[string]         # Display name.
    durationAttributeId*: Option[int32]  # Duration attribute ID.
    effectCategory*: Option[int32]       # Effect category.
    effectId*: int32                     # Effect ID.
    electronicChance*: Option[bool]      # Electronic chance flag.
    falloffAttributeId*: Option[int32]   # Falloff attribute ID.
    iconId*: Option[int32]               # Icon ID.
    isAssistance*: Option[bool]          # Whether this is an assistance effect.
    isOffensive*: Option[bool]           # Whether this is an offensive effect.
    isWarpSafe*: Option[bool]            # Whether safe during warp.
    modifiers*: Option[seq[DogmaEffectModifier]]  # Modifiers for this effect.
    name*: Option[string]               # Effect name.
    postExpression*: Option[int32]       # Post-expression ID.
    preExpression*: Option[int32]        # Pre-expression ID.
    published*: Option[bool]             # Whether the effect is published.
    rangeAttributeId*: Option[int32]     # Range attribute ID.
    rangeChance*: Option[bool]           # Range chance flag.
    trackingSpeedAttributeId*: Option[int32]  # Tracking speed attribute ID.

  DogmaDynamicItemAttribute* = ref object
    attributeId*: int32                  # Attribute ID.
    value*: float                        # Attribute value.

  DogmaDynamicItemEffect* = ref object
    effectId*: int32                     # Effect ID.
    isDefault*: bool                     # Whether this is the default effect.

  DogmaDynamicItem* = ref object
    createdBy*: int32                    # Character ID of the creator.
    dogmaAttributes*: seq[DogmaDynamicItemAttribute]  # Dogma attributes.
    dogmaEffects*: seq[DogmaDynamicItemEffect]        # Dogma effects.
    mutatorTypeId*: int32                # Mutaplasmid type ID used.
    sourceTypeId*: int32                 # Source item type ID.

proc getDogmaAttributes*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## Get a list of dogma attribute IDs.
  let resp = api.get("/dogma/attributes", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

proc getDogmaAttribute*(
  api: Warpy,
  attributeId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[DogmaAttribute] =
  ## Get information on a dogma attribute.
  let resp = api.get("/dogma/attributes/" & $attributeId, ifNoneMatch)
  result = newWarpyResponse[DogmaAttribute](resp)

proc getDogmaEffects*(
  api: Warpy,
  ifNoneMatch: string = ""
): WarpyResponse[seq[int32]] =
  ## Get a list of dogma effect IDs.
  let resp = api.get("/dogma/effects", ifNoneMatch)
  result = newWarpyResponse[seq[int32]](resp)

proc getDogmaEffect*(
  api: Warpy,
  effectId: int32,
  ifNoneMatch: string = ""
): WarpyResponse[DogmaEffect] =
  ## Get information on a dogma effect.
  let resp = api.get("/dogma/effects/" & $effectId, ifNoneMatch)
  result = newWarpyResponse[DogmaEffect](resp)

proc getDogmaDynamicItem*(
  api: Warpy,
  typeId: int32,
  itemId: int64,
  ifNoneMatch: string = ""
): WarpyResponse[DogmaDynamicItem] =
  ## Get info on a dogma dynamic item (abyssal mutated item).
  let resp = api.get("/dogma/dynamic/items/" & $typeId & "/" & $itemId, ifNoneMatch)
  result = newWarpyResponse[DogmaDynamicItem](resp)
