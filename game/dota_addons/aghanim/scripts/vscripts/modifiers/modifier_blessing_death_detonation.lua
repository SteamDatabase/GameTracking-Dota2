modifier_blessing_death_detonation = class({})

--------------------------------------------------------------------------------

function modifier_blessing_death_detonation:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_death_detonation:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
-----------------------------------------------------------------------------------------

function modifier_blessing_death_detonation:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_death_detonation:OnDeath( params )
	if IsServer() ~= true then
		return
	end

	if params.unit == nil or params.unit ~= self:GetParent() then
		return
	end
	local radius = 350
	local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #entities > 0 then
		for _,entity in pairs(entities) do
			if entity ~= nil and entity:IsNull() == false and entity ~= self:GetParent() and ( not entity:IsMagicImmune() ) and ( not entity:IsInvulnerable() ) then
				local DamageInfo =
				{
					victim = entity,
					attacker = self:GetCaster(),
					ability = self,
					damage = self:GetStackCount() * self:GetParent():GetLevel(),
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage( DamageInfo )
			end
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/blessings/death_detonation/death_detonation_remote_mines_detonate.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end
