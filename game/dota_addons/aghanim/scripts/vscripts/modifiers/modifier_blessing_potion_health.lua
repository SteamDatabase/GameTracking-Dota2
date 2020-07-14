require( "modifiers/modifier_blessing_base" )

modifier_blessing_potion_health = class( modifier_blessing_base )

-------------------------------------------------------------------------------

function modifier_blessing_potion_health:OnBlessingCreated( kv )
	self.hp_restore_pct_bonus = kv.hp_restore_pct_bonus
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_health:GetHealthRestorePercentBonus()
	return self.hp_restore_pct_bonus
end
