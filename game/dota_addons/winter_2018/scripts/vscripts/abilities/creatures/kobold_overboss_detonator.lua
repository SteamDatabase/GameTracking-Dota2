
kobold_overboss_detonator = class({})
LinkLuaModifier( "modifier_kobold_overboss_detonator", "modifiers/creatures/modifier_kobold_overboss_detonator", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kobold_overboss_detonator_thinker", "modifiers/creatures/modifier_kobold_overboss_detonator_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function kobold_overboss_detonator:OnSpellStart()
	if IsServer() then 
		local detonator_duration = self:GetSpecialValueFor( "detonator_duration" )
		local search_radius = self:GetSpecialValueFor( "search_radius" )
		local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #allies > 1 then
			local maxHP = nil
			local target = nil
			for _,ally in pairs(allies) do
				local distanceToAlly = (self:GetCaster():GetOrigin() - ally:GetOrigin()):Length()
				local HP = ally:GetHealth()
				if ally:IsAlive() and (maxHP == nil or HP > maxHP) and distanceToAlly < search_radius and ally:HasModifier("modifier_kobold_overboss_detonator") == false and ally:HasModifier("modifier_kobold_overboss_detonator_receiver") == true then
					maxHP = HP
					target = ally
				end
			end

			local kv = 
			{
				duration = self:GetSpecialValueFor( "detonator_duration" ),
				radius = search_radius,
				bounces = self:GetSpecialValueFor( "max_bounces" ),
			}
			target:AddNewModifier( self:GetCaster(), self, "modifier_kobold_overboss_detonator", kv )
		end
	end
end