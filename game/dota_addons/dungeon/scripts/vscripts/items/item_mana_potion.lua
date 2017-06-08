item_mana_potion = class({})

--------------------------------------------------------------------------------

function item_mana_potion:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_mana_potion:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )

		local Heroes = HeroList:GetAllHeroes()
		local nHeroCount = 0
		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:IsAlive() then
				nHeroCount = nHeroCount + 1
			end
		end

		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:IsAlive() then
				local flManaAmount = Hero:GetMaxMana() * mana_restore_pct / 100
				Hero:GiveMana( flManaAmount / nHeroCount )
				
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hero )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------