if  summon_penguin == nil then
	 summon_penguin = class({})
end

LinkLuaModifier( "modifier_summon_mount", "modifiers/gameplay/mounts/modifier_summon_mount", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_mounted", "modifiers/gameplay/mounts/modifier_mounted", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_mount_movement", "modifiers/creatures/mounts/modifier_mount_movement", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_mount_hop_movement", "modifiers/creatures/mounts/modifier_mount_hop_movement", LUA_MODIFIER_MOTION_BOTH )

LinkLuaModifier( "modifier_mount_passive", "modifiers/creatures/mounts/modifier_mount_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mount_impairment", "modifiers/creatures/mounts/modifier_mount_impairment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mount_hit_cooldown", "modifiers/creatures/mounts/modifier_mount_hit_cooldown", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function summon_penguin:GetIntrinsicModifierName()
	return "modifier_summon_mount"
end

--------------------------------------------------------------------------------

function summon_penguin:GetAbilityTextureName()
	local textureName = "seasonal_summon_greeviling_blank"
	if self:GetCaster():HasModifier("modifier_mount_penguin") then textureName = "summon_penguin"
	elseif self:GetCaster():HasModifier("modifier_mount_ogreseal") then textureName = "seasonal_summon_ogreseal"
	elseif self:GetCaster():HasModifier("modifier_mount_snowball") then textureName = "seasonal_throw_snowball"
	elseif self:GetCaster():HasModifier("modifier_mount_frosttoad") then textureName = "seasonal_summon_toad"
	end
	return textureName
end

--------------------------------------------------------------------------------

function summon_penguin:CastFilterResult()
	if self:GetCaster():IsRooted() or self:GetCaster():IsTaunted() then
		return UF_FAIL_CUSTOM
	end
	
	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function summon_penguin:GetCustomCastError()
	if self:GetCaster():IsTaunted() then
		return "#dota_hud_error_ability_inactive"
	end
	
	return "#dota_hud_error_ability_disabled_by_root"
end
--------------------------------------------------------------------------------

function summon_penguin:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function summon_penguin:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------

function summon_penguin:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function summon_penguin:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		if hCaster:IsStunned() or hCaster:IsHexed() or hCaster:IsFrozen() or hCaster:IsRooted() or hCaster:IsTaunted() or hCaster:IsFeared()  then
			hCaster:Interrupt()
			return
		end

		local hMountedModifier = hCaster:FindModifierByName( "modifier_mounted" )
		if hMountedModifier ~= nil then
			-- ignore input for 0.5s after mounting
			if hMountedModifier.flCreationTime ~= nil and hMountedModifier.flCreationTime + 0.5 <= GameRules:GetDOTATime( false, true ) then
				-- Already mounted, so dismount instead of channeling/summoning
				hCaster:Interrupt()
				hCaster:RemoveModifierByName("modifier_mounted")
			end
		else
			-- ensure previous mount despawns
			if self.hMount ~= nil and not self.hMount:IsNull() and not self.hMount:HasModifier("modifier_kill") then
				self.hMount:AddNewModifier(nil, nil, "modifier_kill", { duration = 10 })
				self.hMount = nil
			end

			-- TODO: Cache mount choice
			local mount = ""
			if hCaster:HasModifier("modifier_mount_penguin") then mount = "npc_dota_mount_penguin"
			elseif hCaster:HasModifier("modifier_mount_ogreseal") then mount = "npc_dota_mount_ogreseal"
			elseif hCaster:HasModifier("modifier_mount_snowball") then mount = "npc_dota_mount_snowball"
			elseif hCaster:HasModifier("modifier_mount_frosttoad") then mount = "npc_dota_mount_frosttoad"
			end

			if #mount > 0 then
				local vDirection = hCaster:GetForwardVector()
				vDirection.z = 0.0
				vDirection = vDirection:Normalized()
				local vPos = hCaster:GetAbsOrigin() + vDirection * 100.0
				self.hMount = CreateUnitByName( mount, vPos, true, nil, hCaster, hCaster:GetTeamNumber() )
				self.hMount.flDesiredYaw = hCaster:GetAnglesAsVector().y
				local vAngles = hCaster:GetAngles()
				self.hMount:SetAbsAngles(vAngles.x, vAngles.y, vAngles.z)
				
				if mount == "npc_dota_mount_penguin" and RollPercentage( 20 ) then
					self.hMount:SetBodygroupByName( "hats", 1 )
				end
			end
	
			-- Allow dismount without waiting on the cooldown
			self:EndCooldown()
		end
	end
end
