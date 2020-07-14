
undead_tusk_mage_tombstone = class({})
LinkLuaModifier( "modifier_undead_tusk_mage_tombstone", "modifiers/creatures/modifier_undead_tusk_mage_tombstone", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function undead_tusk_mage_tombstone:Precache( context )

	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_tombstone.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/undead_tusk_mage_sigil.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/skeleton_spawn.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_undead_tusk_tombstone", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_tusk_skeleton", context, -1 )

end

--------------------------------------------------------------------------------

function undead_tusk_mage_tombstone:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function undead_tusk_mage_tombstone:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 60, 60, 60 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 0, 0 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function undead_tusk_mage_tombstone:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function undead_tusk_mage_tombstone:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		local hTombstone = CreateUnitByName( "npc_dota_undead_tusk_tombstone", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hTombstone ~= nil then
			table.insert( self:GetCaster().hTombstones, hTombstone )

			local flDuration = self:GetSpecialValueFor( "duration" )
			hTombstone:AddNewModifier( self:GetCaster(), self, "modifier_undead_tusk_mage_tombstone", { duration = flDuration } )
			hTombstone:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = flDuration } )
			hTombstone:AddNewModifier( self:GetCaster(), nil, "modifier_provides_fow_position", { duration = -1 } )

			local nTombstoneFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_tombstone.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nTombstoneFX, 0, self:GetCursorPosition() )	
			ParticleManager:SetParticleControlEnt( nTombstoneFX, 1, self:GetCaster(), flDuration, "attach_attack1", self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControl( nTombstoneFX, 2, Vector( flDuration, flDuration, duration ) )
			ParticleManager:ReleaseParticleIndex( nTombstoneFX )

			EmitSoundOn( "UndeadTuskMage.Tombstone", hTombstone )
		end
	end
end

--------------------------------------------------------------------------------
