item_tome_of_greater_knowledge = class({})

--------------------------------------------------------------------------------

function item_tome_of_greater_knowledge:Precache( context )
	PrecacheResource( "model", "models/gameplay/attrib_tome_str.vmdl", context )
	PrecacheResource( "particle", "particles/generic_hero_status/hero_levelup.vpcf", context )
end

--------------------------------------------------------------------------------

function item_tome_of_greater_knowledge:OnSpellStart()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsRealHero() then

			for nPlayerID = 0,AGHANIM_PLAYERS-1 do
				local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hPlayerHero then
					local nFXIndex =  ParticleManager:CreateParticle( "particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, hPlayerHero )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					local nXP = ( GetXPNeededToReachNextLevel( hPlayerHero:GetLevel() ) - GetXPNeededToReachNextLevel( hPlayerHero:GetLevel() - 1 ) ) / 2
					hPlayerHero:AddExperience( nXP, DOTA_ModifyXP_Unspecified, false, false )

					EmitSoundOn( "Item.TomeOfKnowledge", hPlayerHero )
				end
			end
		end
		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------