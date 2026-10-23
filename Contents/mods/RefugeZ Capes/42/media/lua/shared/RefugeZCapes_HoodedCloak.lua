require "TimedActions/ISClothingExtraAction"

-- Vanilla unequips the source before loading/copying the replacement visual.
-- Prepare our two cloak variants first, so a missing asset leaves the cape on.
local variants = {
    ["RefugeZCapes.RefugeHoodedLongCloak"] = "RefugeZCapes.RefugeHoodedLongCloakDown",
    ["RefugeZCapes.RefugeHoodedLongCloakDown"] = "RefugeZCapes.RefugeHoodedLongCloak",
}

if not ISClothingExtraAction.RZC_HoodedCloakGuard then
    ISClothingExtraAction.RZC_HoodedCloakGuard = true
    local originalComplete = ISClothingExtraAction.complete

    function ISClothingExtraAction:complete()
        local itemType = self.item and self.item:getFullType()
        local target = itemType and variants[itemType]
        if not target then return originalComplete(self) end
        -- Wearing either cloak for the first time (not yet equipped) also runs
        -- through this action, with extra set to the item's OWN type, not the
        -- switched target -- that is a normal equip, not a hood-state switch,
        -- and must fall through to vanilla or it silently does nothing. Any
        -- other mismatched extra is still rejected, same as before.
        if self.extra == itemType then return originalComplete(self) end
        if self.extra ~= target or self.item:isBroken()
            or not self.character:getInventory():contains(self.item) then
            return false
        end

        local ok, replacement = pcall(self.createItem, self, self.item, target)
        if not ok or not replacement then
            print("[RefugeZCapes] Hood change cancelled: replacement visual unavailable; original cloak retained.")
            return false
        end

        -- Reuse the prepared item with the game's normal inventory/clothing sync.
        -- Only this action instance is changed, and its method is always restored.
        local ownCreateItem = rawget(self, "createItem")
        self.createItem = function() return replacement end
        local completed, result = pcall(originalComplete, self)
        self.createItem = ownCreateItem
        if not completed then error(result) end
        return result
    end
end
