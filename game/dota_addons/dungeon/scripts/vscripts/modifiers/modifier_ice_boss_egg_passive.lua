modifier_ice_boss_egg_passive = class({})

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_passive:GetEffectName()
	if IsServer() then
		if self.bHatching then
			return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet.vpcf";
		end
	end
	return ""
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_passive:OnCreated( kv )
	if IsServer() then
		self.bHatched = false
		self.bHatching = false
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 50, 50, 50 ) )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
	end
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_passive:OnIntervalThink()
	if IsServer() then
		self:Hatch()
		self:StartIntervalThink( -1 )
	end
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_passive:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local friendlies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,friendly in pairs( friendlies ) do
				if friendly:GetUnitName() == "npc_dota_creature_ice_boss" then
					if friendly:FindModifierByName( "modifier_provide_vision" ) == nil then
						friendly:AddNewModifier( params.attacker, self:GetAbility(), "modifier_provide_vision", { duration = -1 } ) 
					end
					friendly.numEggsKilled = friendly.numEggsKilled + 1
					friendly.bEggDied = true
					return
				end
			end
		end
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_passive:Hatch()
	if IsServer() then
		self.bHatched = true
		self:GetParent():ForceKill( false )
		local dragons_to_spawn = self:GetAbility():GetSpecialValueFor( "dragons_to_spawn" )
		for i=1,dragons_to_spawn,1 do
			CreateUnitByName( "npc_dota_creature_baby_ice_dragon", self:GetParent():GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
		end
	end
end

