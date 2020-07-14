
modifier_scarab_priest_summon_mound = class({})

--------------------------------------------------------------

function modifier_scarab_priest_summon_mound:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_scarab_priest_summon_mound:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_scarab_priest_summon_mound:OnCreated( kv )
	if IsServer() then
		self.szSummonedUnitName = kv.summoned_unit 

		local nSmokeFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_exit.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nSmokeFX, 0, self:GetParent():GetAbsOrigin() )	
		ParticleManager:ReleaseParticleIndex( nSmokeFX )

		self:StartIntervalThink( self:GetDuration() - 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_scarab_priest_summon_mound:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_scarab_priest_summon_mound:OnIntervalThink()

	local nUnburrowFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_exit.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nUnburrowFX, 0, self:GetParent():GetAbsOrigin() )	
	ParticleManager:ReleaseParticleIndex( nUnburrowFX )

	EmitSoundOn( "Creature.Burrow.Out", self:GetParent() )
	self:StartIntervalThink( -1 )

end

-------------------------------------------------------------------

function modifier_scarab_priest_summon_mound:OnDestroy()
	if not IsServer() then
		return
	end 

	if self:GetParent():IsAlive() then

		self.bSpawned = true
		local hMinion = CreateUnitByName( self.szSummonedUnitName, self:GetParent():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hMinion ~= nil then

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

		end

		self:GetParent():ForceKill( false )

	end

	UTIL_Remove( self:GetParent() )

end

-------------------------------------------------------------------

function modifier_scarab_priest_summon_mound:OnDeath( params )
	if not IsServer() or params.unit ~= self:GetParent() or self.bSpawned == true then
		return
	end

	EmitSoundOn( "Burrower.HealExplosion", self:GetParent() )

	local nFXIndex2 = ParticleManager:CreateParticle( "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex2, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( 300, 300, 300 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex2 )

end

