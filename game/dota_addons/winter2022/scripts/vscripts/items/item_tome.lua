
item_tome_winter2022 = class({})

--------------------------------------------------------------------------------

function item_tome_winter2022:OnSpellStart()
	if IsServer() then
		local xp_multiplier = self:GetSpecialValueFor( "xp_multiplier" )
		EmitSoundOn( "Item.TomeOfKnowledge.Pickup", self:GetCaster() )

		local nXP = math.ceil( xp_multiplier * GameRules.Winter2022.nXPPerWave )
		print( "Tome consumed. XP: " .. nXP )
		GameRules.Winter2022:GrantGoldAndXP( self:GetCaster(), 0, nXP, "tome" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
