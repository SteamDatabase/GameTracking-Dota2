
modifier_aghsfort_wisp_autoattack = class({})

--------------------------------------------------------------------------------

function modifier_aghsfort_wisp_autoattack:OnCreated( kv )
	self.attack_range = self:GetParent():Script_GetAttackRange()
	self.attack_interval = self:GetAbility():GetSpecialValueFor( "attack_interval" )

	self:StartIntervalThink( self.attack_interval )
end

--------------------------------------------------------------------------------

function modifier_aghsfort_wisp_autoattack:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghsfort_wisp_autoattack:OnRefresh( kv )
	self.radius =self:GetParent():Script_GetAttackRange()
	self.attack_interval = self:GetAbility():GetSpecialValueFor( "attack_interval" )
end


function modifier_aghsfort_wisp_autoattack:OnIntervalThink()
	if IsServer() then
		
		if not self:GetParent():IsAlive() then
			return -1
		end

		if not self:GetParent():FindModifierByName("modifier_aghsfort_wisp_tether") then 
			local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.attack_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
   			if #hEnemies > 0 then
   				for _, hEnemy in pairs( hEnemies ) do
   					if hEnemy ~= nil and hEnemy:IsAlive() == true then
						self:GetParent():PerformAttack( hEnemy, true, true, true, true, true, false, true )
						break
					end
				end
			end
		end
	end
end
