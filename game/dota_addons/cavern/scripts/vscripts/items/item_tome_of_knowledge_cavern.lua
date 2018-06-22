
item_tome_of_knowledge_cavern = class({})

--------------------------------------------------------------------------------

function item_tome_of_knowledge_cavern:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_tome_of_knowledge_cavern:OnSpellStart()
	if IsServer() then
		if self:GetCaster() == nil then
			return
		end

		local fMultiplier = math.sqrt( self:GetCaster():GetLevel() )
		local nExperience = self:GetSpecialValueFor( "xp_bonus" ) * fMultiplier
		self:GetCaster():EmitSoundParams( "DOTA_Item.FaerieSpark.Activate", 0, 0.5, 0)
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 2500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
			if Hero:IsRealHero() and Hero.AddExperience ~= nil then
				Hero:AddExperience( nExperience, DOTA_ModifyXP_Unspecified, false, true )
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hero )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
