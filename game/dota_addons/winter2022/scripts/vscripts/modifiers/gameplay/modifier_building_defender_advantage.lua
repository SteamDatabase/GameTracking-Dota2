
modifier_building_defender_advantage = class({})

--------------------------------------------------------------------------------

--[[
function modifier_building_defender_advantage:IsHidden()
	return true
end
]]

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:OnCreated( kv )
	self.fAuraRadius = 900
	self.fAggroRadius = 1250
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:GetModifierAura()
	return "modifier_building_defender_advantage_buff"
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:GetAuraRadius()
	return self.fAuraRadius
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_building_defender_advantage:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local hAttacker = params.attacker
			if hAttacker == nil or hAttacker:IsNull() then
				return
			end

			local fDistanceToAttacker = ( hAttacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin() ):Length2D()
			if fDistanceToAttacker < self.fAggroRadius then
				-- If my bucket soldier isn't aggro'd, then send soldier at my attacker
				local hAlliedCreeps = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), self.fAggroRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
				for _, hAlliedCreep in ipairs( hAlliedCreeps ) do
					if hAlliedCreep:GetUnitName() == "npc_dota_radiant_bucket_soldier" or hAlliedCreep:GetUnitName() == "npc_dota_dire_bucket_soldier" then
						--[[ this approach doesn't work
						if hAlliedCreep:GetAggroTarget() == nil then
							printf( "bucket soldier has no aggro target, so set its aggro target to be my attacker" )
							hAlliedCreep:SetAggroTarget( hAttacker )
						]]
						if hAlliedCreep:IsAttacking() == false and hAlliedCreep:IsMoving() == false then
							--printf( "bucket soldier is not attacking and isn't moving, so set its aggro target to be my attacker" )
							hAlliedCreep:SetAggroTarget( hAttacker )

							ExecuteOrderFromTable({
								UnitIndex = hAlliedCreep:entindex(),
								OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
								TargetIndex = hAttacker:entindex(),
								Queue = false,
							})
						else
							--printf( "bucket soldier cannot be enlisted to help bucket" )
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
