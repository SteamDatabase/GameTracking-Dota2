sand_king_boss_unburrow = class({})

--------------------------------------------------------------------

function sand_king_boss_unburrow:OnAbilityPhaseStart()
	if IsServer() then
		if self:GetCaster().nBurrowFXIndex == nil then
			return true
		end
		ParticleManager:DestroyParticle( self:GetCaster().nBurrowFXIndex, false )

		EmitSoundOn( "Hero_NyxAssassin.Burrow.Out", self:GetCaster() )
		local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_exit.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
	end
	return true
end

--------------------------------------------------------------------------------

function sand_king_boss_unburrow:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------

function sand_king_boss_unburrow:OnSpellStart()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_sand_king_boss_burrow" )
	end
end