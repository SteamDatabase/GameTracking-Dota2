
storegga_arm_slam = class({})
LinkLuaModifier( "modifier_storegga_arm_slam", "modifiers/creatures/modifier_storegga_arm_slam", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function storegga_arm_slam:Precache( context )

	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )

end

--------------------------------------------------------------------------------

function storegga_arm_slam:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_arm_slam:OnAbilityPhaseStart()
	if IsServer() then
		--self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )

		local kv = {}
		kv["duration"] = self:GetCastPoint()
		--kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_storegga_arm_slam", kv )
	end
	return true
end

--------------------------------------------------------------------------------

function storegga_arm_slam:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_storegga_arm_slam" )
	end
end

--------------------------------------------------------------------------------

function storegga_arm_slam:GetPlaybackRateOverride()
	return 0.55
end

--------------------------------------------------------------------------------

function storegga_arm_slam:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_storegga_arm_slam" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end
