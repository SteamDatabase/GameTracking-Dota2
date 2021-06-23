hellbear_smash = class({})

----------------------------------------------------------------------------------------

function hellbear_smash:Precache( context )

	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/ursa_thunderclap.vpcf", context )

end

--------------------------------------------------------------------------------

function hellbear_smash:OnAbilityPhaseStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.damage = self:GetSpecialValueFor( "damage" )
		self.radius_increase_per_level = self:GetSpecialValueFor( "radius_increase_per_level" )

		local nRadiusIncrease = 0
		

		--print( '^^^HELLBEAR SMASH RADIUS = ' .. self.radius + nRadiusIncrease )

		--self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		--ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		--ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.radius + nRadiusIncrease, self.radius + nRadiusIncrease, self.radius + nRadiusIncrease ) )
		--ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		local fDuration = 1.0

		self.nFriendlyFXIndex = ParticleManager:CreateParticleForTeam( "particles/neutral_fx/tower_mortar_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetTeamNumber() )
		ParticleManager:SetParticleControlEnt( self.nFriendlyFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFriendlyFXIndex, 1, Vector( self.radius + nRadiusIncrease, self.radius + nRadiusIncrease, self.radius + nRadiusIncrease ) )
		ParticleManager:SetParticleControl( self.nFriendlyFXIndex, 2, Vector( fDuration, fDuration, fDuration ) )
		ParticleManager:SetParticleControl( self.nFriendlyFXIndex, 3, Vector( 0.2, 0.3, 1.0 ) )
		ParticleManager:ReleaseParticleIndex( self.nFriendlyFXIndex )

		self.nEnemyFXIndex = ParticleManager:CreateParticleForTeam( "particles/neutral_fx/tower_mortar_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil, FlipTeamNumber( self:GetCaster():GetTeamNumber() ) )
		ParticleManager:SetParticleControlEnt( self.nEnemyFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nEnemyFXIndex, 1, Vector( self.radius + nRadiusIncrease, self.radius + nRadiusIncrease, self.radius + nRadiusIncrease ) )
		ParticleManager:SetParticleControl( self.nEnemyFXIndex, 2, Vector( fDuration, fDuration, fDuration ) )
		ParticleManager:SetParticleControl( self.nEnemyFXIndex, 3, Vector( 1.0, 0.3, 0.2 ) )
		ParticleManager:ReleaseParticleIndex( self.nEnemyFXIndex )

		EmitSoundOn( "Hellbear.Smash", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function hellbear_smash:OnAbilityPhaseInterrupted()
	if IsServer() then
		--if self.nPreviewFX then
		--	ParticleManager:DestroyParticle( self.nPreviewFX, false )
		--	self.nPreviewFX = nil
		--end

		if self.nFriendlyFXIndex then
			ParticleManager:DestroyParticle( self.nFriendlyFXIndex, false )
			self.nFriendlyFXIndex = nil
		end
		if self.nEnemyFXIndex then
			ParticleManager:DestroyParticle( self.nEnemyFXIndex, false )
			self.nEnemyFXIndex = nil
		end
	end 
end

--------------------------------------------------------------------------------

function hellbear_smash:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------------

-- another possible solution to the CastPoint issue
-- as the model scale goes up, the anim slows down
-- this has been disabled in abilities_custom, but if it's 
--[[
function hellbear_smash:GetCastPoint()
	local fCastPoint = self.BaseClass.GetCastPoint( self )
	print( 'Original Cast point = ' .. fCastPoint )
	
	local hCreatureBuff = self:GetCaster():FindModifierByName( 'modifier_creature_buff' )
	if hCreatureBuff ~= nil then
		local nCreatureBuffLevel = hCreatureBuff.level
		print( 'Creature Buff Level = ' .. nCreatureBuffLevel )
		fCastPoint = fCastPoint * ( 1 + ( nCreatureBuffLevel * 0.07 ) )
	end

	print( 'New Cast point = ' .. fCastPoint )
	return fCastPoint
end
]]--

--------------------------------------------------------------------------------

function hellbear_smash:OnSpellStart()
	if IsServer() then
		local nRadiusIncrease = 0
		local hCreatureBuff = self:GetCaster():FindModifierByName( 'modifier_creature_buff' )
		if hCreatureBuff ~= nil then
			local nCreatureBuffLevel = hCreatureBuff.level
			--print( 'Creature Buff Level = ' .. nCreatureBuffLevel )
			nRadiusIncrease = self.radius_increase_per_level * nCreatureBuffLevel
		end

		--if self.nPreviewFX then
		--	ParticleManager:DestroyParticle( self.nPreviewFX, false )
		--	self.nPreviewFX = nil
		--end

		if self.nFriendlyFXIndex then
			ParticleManager:DestroyParticle( self.nFriendlyFXIndex, false )
			self.nFriendlyFXIndex = nil
		end
		if self.nEnemyFXIndex then
			ParticleManager:DestroyParticle( self.nEnemyFXIndex, false )
			self.nEnemyFXIndex = nil
		end


		--debugoverlay:Sphere( self:GetCaster():GetOrigin(), self.radius + nRadiusIncrease, 200, 20, 20, 255, false, 1.0 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/neutral_fx/ursa_thunderclap.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius + nRadiusIncrease, self.radius + nRadiusIncrease, self.radius + nRadiusIncrease ) )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		--EmitSoundOn( "Hellbear.Smash", self:GetCaster() )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius + nRadiusIncrease, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				}
				ApplyDamage( damageInfo )
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_polar_furbolg_ursa_warrior_thunder_clap", { duration = self.duration } )
			end
		end
	
	end
end

--------------------------------------------------------------------------------