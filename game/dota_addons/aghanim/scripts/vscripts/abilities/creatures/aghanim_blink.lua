aghanim_blink = class{}

----------------------------------------------------------------------------------------

function aghanim_blink:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_preimage.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context )
end

----------------------------------------------------------------------------------------

function aghanim_blink:OnSpellStart()
	if IsServer() == false then
		return
	end
	
	local vPos =  self:GetCursorPosition()
	local vDirection = vPos - self:GetCaster():GetOrigin()
	local flDist = vDirection:Length2D()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()
	
	--local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_preimage.vpcf", PATTACH_CUSTOMORIGIN, nil )--
	--ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
	--ParticleManager:SetParticleControl( nFXIndex, 1, vPos )
	--ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	--ParticleManager:SetParticleFoWProperties( nFXIndex, 0, 2, 64.0 )
	--ParticleManager:ReleaseParticleIndex( nFXIndex )

	self.vStartLocation = self:GetCaster():GetAbsOrigin()

	local info = 
	{
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = 0,
		fEndRadius = 0,
		vVelocity = vDirection * flDist,
		fDistance = flDist,
		Source = self:GetCaster(),
		--iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		--iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster() )
end

----------------------------------------------------------------------------------------

function aghanim_blink:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		local vDirection = vLocation - self:GetCaster():GetAbsOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster() )

		FindClearSpaceForUnit( self:GetCaster(), vLocation, true )
		--self:GetCaster():FaceTowards( self:GetCaster().vHomePosition )

		ProjectileManager:ProjectileDodge( self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_preimage.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self.vStartLocation )
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self.vStartLocation, true )
		ParticleManager:SetParticleFoWProperties( nFXIndex, 0, 2, 64.0 )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	return true
end

----------------------------------------------------------------------------------------