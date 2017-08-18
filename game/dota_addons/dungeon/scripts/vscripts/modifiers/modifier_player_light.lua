
modifier_player_light = class({})

--------------------------------------------------------------------------------

--[[
function modifier_player_light:GetEffectName()
	return "particles/addons_gameplay/player_deferred_light.vpcf"
end
]]

--------------------------------------------------------------------------------

function modifier_player_light:OnCreated( kv )
	if IsServer() then
		local hPlayerHero = self:GetParent()
        if hPlayerHero ~= nil then
            local nLightParticleID = ParticleManager:CreateParticle( "particles/addons_gameplay/player_deferred_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, hPlayerHero )
            ParticleManager:SetParticleControlEnt( nLightParticleID, PATTACH_ABSORIGIN_FOLLOW, hPlayerHero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
            hPlayerHero.nLightParticleID = nLightParticleID
        end
	end
end

--------------------------------------------------------------------------------

