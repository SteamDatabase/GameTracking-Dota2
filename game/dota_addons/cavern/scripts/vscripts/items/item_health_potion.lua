
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

		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 2500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
			local flHealAmount = Hero:GetMaxHealth() * hp_restore_pct / 100
			Hero:Heal( flHealAmount / #Heroes, self )

			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hero )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
