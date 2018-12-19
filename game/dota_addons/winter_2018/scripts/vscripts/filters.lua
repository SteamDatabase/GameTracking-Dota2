---------------------------------------------------------------------------
--	ModifierGainedFilter
--  *entindex_parent_const
--	*entindex_ability_const
--	*entindex_caster_const
--	*name_const
--	*duration
---------------------------------------------------------------------------

function CHoldout:ModifierGainedFilter( filterTable )
	if filterTable["entindex_parent_const"] == nil then 
		return true
	end

 	if filterTable["name_const"] == nil then
		return true
	end

	local szBuffName = filterTable["name_const"]
	local hParent = EntIndexToHScript( filterTable["entindex_parent_const"] )
	local hBuff = nil
	if hParent ~= nil then
		hBuff = hParent:FindModifierByName( szBuffName )
	end

	if hBuff == nil then
		return true
	end

	if hParent == self._hRubick then
		if 	szBuffName == "modifier_stunned" or
			szBuffName == "modifier_sheepstick_debuff" or
			szBuffName == "modifier_bloodthorn_debuff" or
			szBuffName == "modifier_orchid_malevolence_debuff" or
			szBuffName == "modifier_bashed" or
			szBuffName == "modifier_silence" or 
			szBuffName == "modifier_rooted" or 
			szBuffName == "modifier_faceless_void_timelock_freeze" or
			szBuffName == "modifier_dark_willow_debuff_fear" then
			return false
		end
	end

	return true
end