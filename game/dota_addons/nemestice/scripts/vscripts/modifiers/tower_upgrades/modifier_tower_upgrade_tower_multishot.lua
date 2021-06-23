
if modifier_tower_upgrade_tower_multishot == nil then
	modifier_tower_upgrade_tower_multishot = class( {} )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_multishot:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_multishot:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_gyrocopter/gyro_flak_cannon_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		self:AddParticle( nFXIndex, false, false, -1, false, true );
	end
	self:OnRefresh( kv )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_multishot:OnRefresh( kv )
	self.bonus_attacks = 2
	if kv.bonus_attacks ~= nil then
		self.bonus_attacks = kv.bonus_attacks
	elseif self:GetAbility() then
		self.bonus_attacks = self:GetAbility():GetSpecialValueFor( "bonus_attacks" ) or 2
	end
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_multishot:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_multishot:OnAttack( params )
	if IsServer() == false then
		return 0
	end

	if self:GetParent() ~= params.attacker then
		return 0
	end

	if params.no_attack_cooldown then
		return
	end

	if params.target == nil then
		return 0
	end

	local nBonusAttacksLeft = self.bonus_attacks

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), self:GetParent():Script_GetAttackRange() + 24.0, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NOT_NIGHTMARED, FIND_CLOSEST, false )
	for _,hEnemy in pairs( enemies ) do
		if hEnemy ~= params.target then
			self:GetParent():PerformAttack( hEnemy, true, true, true, true, true, false, false )
			nBonusAttacksLeft = nBonusAttacksLeft - 1
			if nBonusAttacksLeft <= 0 then
				break
			end
		end
	end

	return 0
end