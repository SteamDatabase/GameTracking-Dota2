furion_teleportation_lua = class({})
LinkLuaModifier( "modifier_furion_teleportation_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function furion_teleportation_lua:OnAbilityPhaseStart()
	self.vTargetPosition = self:GetCursorPosition()
	local nTeam = self:GetCaster():GetTeamNumber()
	local nEnemyTeam = nil
	if nTeam == DOTA_TEAM_GOODGUYS then
		nEnemyTeam = DOTA_TEAM_BADGUYS
	else
		nEnemyTeam = DOTA_TEAM_GOODGUYS
	end

	self.nFXIndexStart = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( self.nFXIndexStart, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( self.nFXIndexStart, 2, Vector( 1, 0, 0 ) )

	self.nFXIndexEnd = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_furion/furion_teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil, nEnemyTeam )
	ParticleManager:SetParticleControl( self.nFXIndexEnd, 1, self.vTargetPosition )
	ParticleManager:SetParticleControl( self.nFXIndexEnd, 2, Vector ( 1, 0, 0 ) )

	self.nFXIndexEndTeam = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_furion/furion_teleport_end_team.vpcf", PATTACH_CUSTOMORIGIN, nil, nTeam )
	ParticleManager:SetParticleControl( self.nFXIndexEndTeam, 1, self.vTargetPosition )
	ParticleManager:SetParticleControl( self.nFXIndexEndTeam, 2, Vector ( 1, 0, 0 ) )

	MinimapEvent( nTeam, self:GetCaster(), self.vTargetPosition.x, self.vTargetPosition.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, self:GetCastPoint() )

	local kv = {
		duration = self:GetCastPoint(),
		target_x = self.vTargetPosition.x,
		target_y = self.vTargetPosition.y,
		target_z = self.vTargetPosition.z
	}

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_furion_teleportation_lua", kv )


	return true;
end

--------------------------------------------------------------------------------

function furion_teleportation_lua:OnAbilityPhaseInterrupted()
	ParticleManager:SetParticleControl( self.nFXIndexStart, 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.nFXIndexEnd, 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.nFXIndexEndTeam, 2, Vector( 0, 0, 0 ) )

	ParticleManager:DestroyParticle( self.nFXIndexStart, false )
	ParticleManager:DestroyParticle( self.nFXIndexEnd, false )
	ParticleManager:DestroyParticle( self.nFXIndexEndTeam, false )

	self:GetCaster():RemoveModifierByName( "modifier_furion_teleportation_lua" )

	MinimapEvent( self:GetCaster():GetTeamNumber(), self:GetCaster(), 0, 0, DOTA_MINIMAP_EVENT_CANCEL_TELEPORTING, 0 )
end

--------------------------------------------------------------------------------

function furion_teleportation_lua:OnSpellStart()
	ProjectileManager:ProjectileDodge( self:GetCaster() )
	FindClearSpaceForUnit( self:GetCaster(), self.vTargetPosition, true )
	self:GetCaster():StartGesture( ACT_DOTA_TELEPORT_END )

	ParticleManager:DestroyParticle( self.nFXIndexStart, false )
	ParticleManager:DestroyParticle( self.nFXIndexEnd, false )
	ParticleManager:DestroyParticle( self.nFXIndexEndTeam, false )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------