
sand_king_tail_swipe_right = class({})

--------------------------------------------------------------------

function sand_king_tail_swipe_right:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )

end

--------------------------------------------------------------------------------

function sand_king_tail_swipe_right:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )

		local kv = {}
		kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sand_king_tail_swipe", kv )
	end
	return true
end

--------------------------------------------------------------------------------

function sand_king_tail_swipe_right:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_sand_king_tail_swipe" )
	end
end

--------------------------------------------------------------------------------

function sand_king_tail_swipe_right:GetPlaybackRateOverride()
	return 0.6
end

--------------------------------------------------------------------------------

function sand_king_tail_swipe_right:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_sand_king_tail_swipe" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end
