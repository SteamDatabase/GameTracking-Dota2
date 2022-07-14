dark_seer_wall_of_replica_nb2017 = class({})
LinkLuaModifier( "modifier_dark_seer_wall_of_replica_nb2017", "modifiers/modifier_dark_seer_wall_of_replica_nb2017", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function dark_seer_wall_of_replica_nb2017:OnAbilityUpgrade( hAbility )
	if IsServer() == false then 
		return
	end

	self.BaseClass.OnAbilityUpgrade( self, hAbility )
	self:EnableAbilityChargesOnTalentUpgrade( hAbility, "special_bonus_unique_dark_seer_4" )
end

--------------------------------------------------------------------------------

function dark_seer_wall_of_replica_nb2017:GetCooldownOrChargeRestoreTime( nLevel )
	local nBaseCooldown = self.BaseClass.GetCooldown( self, nLevel )

	if self:GetCaster() then 
		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_dark_seer_13" )
		if hTalent and hTalent:GetLevel() > 0 then 
			nBaseCooldown = nBaseCooldown  - hTalent:GetSpecialValueFor( "value" )
		end
	end

	return nBaseCooldown
end

--------------------------------------------------------------------------------

function dark_seer_wall_of_replica_nb2017:GetCooldown( nLevel )
	if self:GetCaster() then 
		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_dark_seer_4" )
		if hTalent and hTalent:GetLevel() > 0 then 
			return 0.5
		end
	end

	return self:GetCooldownOrChargeRestoreTime( nLevel )
end

--------------------------------------------------------------------------------

function dark_seer_wall_of_replica_nb2017:GetAbilityChargeRestoreTime( nLevel )
	if self:GetCaster() then 
		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_dark_seer_4" )
		if hTalent and hTalent:GetLevel() > 0 then 
			return self:GetCooldownOrChargeRestoreTime( nLevel )
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function dark_seer_wall_of_replica_nb2017:OnSpellStart()	
	local vWallDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vWallDirection = vWallDirection:Normalized();

	local kv =
	{
		duration = self:GetSpecialValueFor( "duration" ),
		dir_x = vWallDirection.x,
		dir_y = vWallDirection.y,
		dir_z = vWallDirection.z
	}

	CreateModifierThinker( self:GetCaster(), self, "modifier_dark_seer_wall_of_replica_nb2017", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------
