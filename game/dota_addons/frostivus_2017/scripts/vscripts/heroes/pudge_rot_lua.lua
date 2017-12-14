pudge_rot_lua = class({})
LinkLuaModifier( "modifier_rot_lua", "heroes/modifiers/modifier_rot_lua.lua" ,LUA_MODIFIER_MOTION_NONE )


function pudge_rot_lua:OnToggle()
    if self:GetToggleState() then
        -- Toggle On
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_rot_lua", nil )

        if not self:GetCaster():IsChanneling() then
            self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_ROT )
        end
    else
        -- Toggle Off
        local rotModifier = self:GetCaster():FindModifierByName( "modifier_rot_lua" )
        if rotModifier ~= nil then
            rotModifier:Destroy()
        end
    end
end