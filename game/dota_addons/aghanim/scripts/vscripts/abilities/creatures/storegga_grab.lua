
storegga_grab = class({})
LinkLuaModifier( "modifier_storegga_grab", "modifiers/creatures/modifier_storegga_grab", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_storegga_grabbed_buff", "modifiers/creatures/modifier_storegga_grabbed_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_storegga_grabbed_debuff", "modifiers/creatures/modifier_storegga_grabbed_debuff", LUA_MODIFIER_MOTION_BOTH )

----------------------------------------------------------------------------------------

function storegga_grab:Precache( context )

	PrecacheResource( "particle", "particles/test_particle/generic_attack_crit_blur.vpcf", context )

end

--------------------------------------------------------------------------------

function storegga_grab:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_grab:OnAbilityPhaseStart()
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_storegga_grabbed_buff" ) ~= nil then
			return false
		end
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )

		local kv = {}
		kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay
		local hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_storegga_grab", kv )
		if hBuff ~= nil then
			hBuff.hTarget = self:GetCursorTarget()
		end
	end
	return true
end

--------------------------------------------------------------------------------

function storegga_grab:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_storegga_grab" )
	end
end

--------------------------------------------------------------------------------

--[[
function storegga_grab:GetPlaybackRateOverride()
	return 0.35
end
]]

--------------------------------------------------------------------------------

function storegga_grab:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_storegga_grab" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 