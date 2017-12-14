function OnPickUp(keys)
    local caster = keys.caster
    GameMode.currentGame:OnCoinPickedUp(caster)
end