require( "modifiers/modifier_blessing_base" )

modifier_blessing_potion_mana = class( modifier_blessing_base )

-------------------------------------------------------------------------------

function modifier_blessing_potion_mana:OnBlessingCreated( kv )
	self.mana_restore_pct_bonus = kv.mana_restore_pct_bonus
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_mana:GetManaRestorePercentBonus()
	return self.mana_restore_pct_bonus
end
