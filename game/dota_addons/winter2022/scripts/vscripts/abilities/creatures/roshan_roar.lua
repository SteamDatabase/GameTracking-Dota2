if roshan_roar == nil then
	roshan_roar = class({})
end

LinkLuaModifier( "modifier_roshan_roar", "modifiers/creatures/modifier_roshan_roar", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function roshan_roar:Precache( context )
	PrecacheResource( "particle", "particles/neutral_fx/roshan_slam.vpcf", context )
end

--------------------------------------------------------------------------------
function roshan_roar:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------
function roshan_roar:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------
function roshan_roar:IsStealable()
	return false
end

--------------------------------------------------------------------------------
function roshan_roar:OnAbilityPhaseStart()
    if not IsServer() then return end
end

--------------------------------------------------------------------------------
function roshan_roar:OnSpellStart()
    if not IsServer() then return end

    local base_damage = self:GetSpecialValueFor("base_damage")
    local damage_increment = self:GetSpecialValueFor("damage_increment")
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")

    local nTargetFlags = DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local hUnits = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), nTargetFlags, 0, false )
	for _, hUnit in pairs( hUnits ) do
        local isHero = hUnit:IsHero()
        local flModifierDuration = isHero and duration or ( duration * 2 )
        hUnit:AddNewModifier( self:GetCaster(), self, "modifier_roshan_roar", { duration = flModifierDuration } )

        local damage = base_damage + math.floor( GameRules:GetDOTATime(false, false) / 60.0) * damage_increment

        local DamageInfo =
        {
            victim = hUnit,
            attacker = self:GetCaster(),
            ability = self,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
        }
        ApplyDamage( DamageInfo )
    end
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
end