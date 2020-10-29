
modifier_spider_death_explosion = class({})

--------------------------------------------------------------

function modifier_spider_death_explosion:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_spider_death_explosion:IsPurgable()
	return false
end

--------------------------------------------------------------

function modifier_spider_death_explosion:OnCreated()
	local min_delay = self:GetAbility():GetSpecialValueFor( "min_delay_time" )
	local max_delay = self:GetAbility():GetSpecialValueFor( "max_delay_time" )
	--printf( 'min = %f, max = %f\n', min_delay, max_delay )

	EmitSoundOn( "Ability.PumpkinGiantExplosion.Priming", self:GetParent() )

	local delay = RandomFloat( min_delay, max_delay )
	self:StartIntervalThink( delay )

	if IsServer() then

		self:GetParent():StartGesture( ACT_DOTA_DISABLED )

		local radius = self:GetAbility():GetSpecialValueFor( "radius" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/pumpkin_giant/pumpkin_giant_explosion_warning.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( delay, delay, delay ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

---------------------------------------------------------

function modifier_spider_death_explosion:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

--------------------------------------------------------------

function modifier_spider_death_explosion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_MODEL_SCALE
	}

	return funcs
end
-------------------------------------------------------------------

function modifier_spider_death_explosion:OnIntervalThink()
	if not IsServer() then
		return
	end
		
	if self:GetAbility() == nil then
		return
	end

	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	local knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	local knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )
	
	local spiders_to_spawn = self:GetAbility():GetSpecialValueFor( "spiders_to_spawn" )
	local spider_knockback_duration = self:GetAbility():GetSpecialValueFor( "spider_knockback_duration" )
	local spider_knockback_distance = self:GetAbility():GetSpecialValueFor( "spider_knockback_distance" )
	local spider_knockback_height = self:GetAbility():GetSpecialValueFor( "spider_knockback_height" )

	EmitSoundOn( "Ability.PumpkinGiantExplosion.Detonate", self:GetParent() )

	local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex2 )

	local nTeam = DOTA_UNIT_TARGET_TEAM_ENEMY

	local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, nTeam, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	if #entities > 0 then
		for _,entity in pairs(entities) do
			if entity ~= nil and entity:IsNull() == false and entity ~= self:GetParent() and ( not entity:IsMagicImmune() ) and ( not entity:IsInvulnerable() ) then
--[[				local DamageInfo =
				{
					victim = entity,
					attacker = self:GetCaster(),
					ability = self,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage( DamageInfo )
--]]

				local DamageInfo =
				{
					victim = entity,
					attacker = self:GetParent(),
					ability = self:GetAbility(),
					damage = damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
				}
				ApplyDamage( DamageInfo )

				local kv =
				{
					center_x = self:GetParent():GetAbsOrigin().x,
					center_y = self:GetParent():GetAbsOrigin().y,
					center_z = self:GetParent():GetAbsOrigin().z,
					should_stun = true, 
					duration = knockback_duration,
					knockback_duration = knockback_duration,
					knockback_distance = knockback_distance,
					knockback_height = knockback_height,
				}

				entity:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", kv )
			end
		end
	end

	for i=1, spiders_to_spawn do
		local vecPosition = self:GetParent():GetAbsOrigin() + RandomVector( RandomFloat( 100, 275 ) )
		local hSpider = CreateUnitByName( "npc_dota_creature_newborn_spider", vecPosition, true, nil, nil, self:GetParent():GetTeamNumber() )
		if hSpider:IsCreature() then
			hSpider:SetRequiresReachingEndPath( true )
		end
		hSpider:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
		hSpider:SetMustReachEachGoalEntity( self:GetCaster():GetMustReachEachGoalEntity() )

		local fSpiderKnockbackDuration = spider_knockback_duration * RandomFloat( 0.8, 1.2 )

		local kv =
		{
			center_x = self:GetParent():GetAbsOrigin().x,
			center_y = self:GetParent():GetAbsOrigin().y,
			center_z = self:GetParent():GetAbsOrigin().z,
			should_stun = true, 
			duration = fSpiderKnockbackDuration,
			knockback_duration = fSpiderKnockbackDuration,
			knockback_distance = spider_knockback_distance,
			knockback_height = spider_knockback_height,
		}

		hSpider:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", kv )
	end

	self:GetParent():AddEffects( EF_NODRAW )
	self:GetParent():ForceKill( false )
end

--------------------------------------------------------------------------------

function modifier_spider_death_explosion:GetMinHealth( params )
	if IsServer() then
		return 1
	end
	return 0
end 

--------------------------------------------------------------------------------

function modifier_spider_death_explosion:GetModifierModelScale( params )
	if self:GetCaster() == nil then
		return 0
	end

	return 35
end
