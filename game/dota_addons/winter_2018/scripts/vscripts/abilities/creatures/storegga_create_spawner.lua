
storegga_create_spawner = class({})

LinkLuaModifier( "modifier_storegga_spawn_children_thinker", "modifiers/creatures/modifier_storegga_spawn_children_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

--[[
function storegga_create_spawner:OnAbilityPhaseStart()
	if IsServer() then
		print( "storegga_create_spawner:OnAbilityPhaseStart()" )
		-- Cast Preview
		self.nCastPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nCastPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nCastPreviewFX, 1, Vector( 50, 50, 50 ) )
		ParticleManager:SetParticleControl( self.nCastPreviewFX, 15, Vector( 25, 150, 255 ) )
	end
end

--------------------------------------------------------------------------------

function storegga_create_spawner:OnAbilityPhaseInterrupted()
	if IsServer() then
		print( "storegga_create_spawner:OnAbilityPhaseInterrupted()" )
		ParticleManager:DestroyParticle( self.nCastPreviewFX, false )
	end
end
]]

--------------------------------------------------------------------------------

function storegga_create_spawner:OnSpellStart()
	if IsServer() then
		--ParticleManager:DestroyParticle( self.nCastPreviewFX, false )

		local vThinkerSpawnPos = self:GetCaster():GetAbsOrigin() + ( self:GetCaster():GetForwardVector() * 150 )
		CreateModifierThinker( self:GetCaster(), self, "modifier_storegga_spawn_children_thinker", kv, vThinkerSpawnPos, self:GetCaster():GetTeamNumber(), false )	
	end
end

--------------------------------------------------------------------------------
