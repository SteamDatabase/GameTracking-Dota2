
item_health_potion = class({})

--------------------------------------------------------------------------------

function item_health_potion:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_health_potion:OnSpellStart()
	if IsServer() then
		local hp_restore_pct = self:GetSpecialValueFor( "hp_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.FaerieSpark.Activate", 0, 0.5, 0)

		local nTeamNumber = self:GetCaster():GetTeamNumber()

		local Heroes = HeroList:GetAllHeroes()

		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:IsAlive() and Hero:GetTeamNumber() == nTeamNumber and Hero:HasModifier( "modifier_event_slark_greed" ) == false then
				local hBlessing = Hero:FindModifierByName( "modifier_blessing_potion_health" )
				if hBlessing ~= nil then
					local nBonusHealPct = hBlessing:GetHealthRestorePercentBonus()
					hp_restore_pct = hp_restore_pct * ( ( 100 + nBonusHealPct ) / 100 )
					--print( 'item_health_potion:OnSpellStart - adding ' .. nBonusHealPct .. '% to heal. Final heal % is ' .. hp_restore_pct )
				end

				local flHealAmount = Hero:GetMaxHealth() * hp_restore_pct / 100
				Hero:Heal( flHealAmount, self )

				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hero )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end

		self:SpendCharge()
	end
end
