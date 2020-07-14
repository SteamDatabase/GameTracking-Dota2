
sand_king_boss_move_back = class({})

-----------------------------------------------------------------

function sand_king_boss_move_back:OnAbilityPhaseStart()
	if IsServer() then
		local flMin = self:GetSpecialValueFor( "minimum_duration" )
		local flMax = self:GetSpecialValueFor( "maximum_duration" )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sand_king_boss_directional_move", { duration = RandomFloat( flMin, flMax ) } )
	end
	return true
end

-----------------------------------------------------------------------------

function sand_king_boss_move_back:GetPlaybackRateOverride()
	return 0.6
end

-----------------------------------------------------------------

function sand_king_boss_move_back:OnSpellStart()
	if IsServer() then
	end
end
