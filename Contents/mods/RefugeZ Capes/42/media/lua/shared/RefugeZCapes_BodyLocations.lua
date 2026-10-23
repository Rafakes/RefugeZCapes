-- The actual identifiers are created in 42/media/registries.lua (loaded before this
-- file, before any other Lua/scripts -- required for custom ItemBodyLocation ids since
-- B42.13). Here we just add the already-registered locations to the "Human" body
-- location group, which is what actually makes them usable equip slots.
local group = BodyLocations.getGroup("Human")
group:getOrCreateLocation(ItemBodyLocation.get(ResourceLocation.of("RefugeZCapes:Cloak")))
-- Independent cosmetic slot: no exclusivity with capes or backpacks.
group:getOrCreateLocation(ItemBodyLocation.get(ResourceLocation.of("RefugeZCapes:DemonWings")))

-- The raised hood occupies the head and cape space but leaves ordinary jackets
-- available underneath. Vanilla exclusivity handles equipment on both peers.
local hoodedCloak = ItemBodyLocation.get(ResourceLocation.of("RefugeZCapes:HoodedCloak"))
group:getOrCreateLocation(hoodedCloak)
for _, location in ipairs({
    ItemBodyLocation.HAT, ItemBodyLocation.FULL_HAT,
    ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.JACKET_HAT, ItemBodyLocation.JACKET_HAT_BULKY,
    ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.FULL_TOP,
    ItemBodyLocation.SCARF, ItemBodyLocation.get(ResourceLocation.of("RefugeZCapes:Cloak")),
}) do
    group:setExclusive(hoodedCloak, location)
end
