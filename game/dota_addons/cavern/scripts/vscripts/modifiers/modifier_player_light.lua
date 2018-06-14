
modifier_player_light = class({})

--------------------------------------------------------------------------------

function modifier_player_light:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_player_light:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_player_light:OnCreated( kv )
	if IsServer() then
		local hPlayerHero = self:GetParent()
		if hPlayerHero ~= nil then
			self.nLightParticleID = ParticleManager:CreateParticle( "particles/cavern_player_deferred_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, hPlayerHero )
			ParticleManager:SetParticleControlEnt( self.nLightParticleID, PATTACH_ABSORIGIN_FOLLOW, hPlayerHero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
			--hPlayerHero.nLightParticleID = self.nLightParticleID
		end
	end
end

--------------------------------------------------------------------------------

function modifier_player_light:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nLightParticleID, true )
	end
end

--------------------------------------------------------------------------------
