
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

		local nTeamNumber = self:GetCaster():GetTeamNumber()

		local Heroes = HeroList:GetAllHeroes()

		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:IsAlive() and Hero:GetTeamNumber() == nTeamNumber then
				local hBlessing = Hero:FindModifierByName( "modifier_blessing_potion_mana" )
				if hBlessing ~= nil then
					local nBonusManaPct = hBlessing:GetManaRestorePercentBonus()
					mana_restore_pct = mana_restore_pct * ( ( 100 + nBonusManaPct ) / 100 )
					--print( 'item_mana_potion:OnSpellStart - adding ' .. nBonusManaPct .. '% to mana. Final mana % is ' .. mana_restore_pct )
				end

				local flManaAmount = Hero:GetMaxMana() * mana_restore_pct / 100
				Hero:GiveMana( flManaAmount )
				
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hero )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
