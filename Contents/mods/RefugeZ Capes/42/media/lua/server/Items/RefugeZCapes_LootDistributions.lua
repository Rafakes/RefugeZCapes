-- RefugeZ Capes loot: server-side, before B42 distribution merge.
require "Items/ProceduralDistributions"

local capesAndShawls = {
    "RefugeZCapes.RefugeAnimeCloak",
    "RefugeZCapes.RefugeAshCloak",
    "RefugeZCapes.RefugeCloak",
    "RefugeZCapes.RefugeCloak_Hand",
    "RefugeZCapes.RefugeCloak_Moon",
    "RefugeZCapes.RefugeCloak_Raven",
    "RefugeZCapes.RefugeCloak_Stag",
    "RefugeZCapes.RefugeCloak_Sun",
    "RefugeZCapes.RefugeEclipseCloak",
    "RefugeZCapes.RefugeHoodedLongCloak",
    "RefugeZCapes.RefugeHoodedLongCloakDown",
    "RefugeZCapes.RefugeHunterCloak",
    "RefugeZCapes.RefugeLongCloak",
    "RefugeZCapes.RefugeLongCloak_Hand",
    "RefugeZCapes.RefugeLongCloak_Moon",
    "RefugeZCapes.RefugeLongCloak_Raven",
    "RefugeZCapes.RefugeLongCloak_Stag",
    "RefugeZCapes.RefugeLongCloak_Sun",
    "RefugeZCapes.RefugeMistCloak",
    "RefugeZCapes.RefugeRavenPlumeCloak",
    "RefugeZCapes.RefugeTatteredShawl",
    "RefugeZCapes.RefugeWandererCloak",
    "RefugeZCapes.RefugeWoolShawl",
}
local wings = {
    "RefugeZCapes.ButterflyWings",
    "RefugeZCapes.ButterflyWings_Emerald",
    "RefugeZCapes.ButterflyWings_Gold",
    "RefugeZCapes.ButterflyWings_Pink",
    "RefugeZCapes.ButterflyWings_Violet",
    "RefugeZCapes.DemonWings",
    "RefugeZCapes.DemonWings_Azure",
    "RefugeZCapes.DemonWings_RedBlack",
    "RefugeZCapes.DemonWings_Scarlet",
    "RefugeZCapes.DemonWings_Venom",
    "RefugeZCapes.DemonWings_Violet",
}
local locations = {
    { name = "WardrobeGeneric", items = capesAndShawls },
    { name = "WardrobeClassy", items = capesAndShawls },
    { name = "ClothingStorageWinter", items = capesAndShawls },
    { name = "ClothingStoresJackets", items = capesAndShawls },
    { name = "WardrobeClassy", items = wings },
    { name = "ClothingStoresSport", items = wings },
}

local function addRareLoot()
    local options = SandboxVars and SandboxVars.RefugeZCapes
    if options and options.EnableLoot == false then return end
    local weight = tonumber(options and options.LootWeight) or 0.005
    if weight <= 0 then return end
    weight = math.min(weight, 1)
    local distributions = ProceduralDistributions and ProceduralDistributions.list
    if not distributions then return end
    for _, location in ipairs(locations) do
        local distribution = distributions[location.name]
        local entries = distribution and distribution.items
        if entries then
            for _, itemType in ipairs(location.items) do
                local exists = false
                for index = 1, #entries, 2 do
                    if entries[index] == itemType then exists = true; break end
                end
                if not exists then
                    entries[#entries + 1] = itemType
                    entries[#entries + 1] = weight
                end
            end
        end
    end
end

Events.OnPreDistributionMerge.Add(addRareLoot)
