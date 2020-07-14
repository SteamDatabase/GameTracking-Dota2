---------------------------------------------------------------------------
--	HealingFilter
--  *entindex_target_const
--	*entindex_healer_const
--	*entindex_inflictor_const
--	*heal
---------------------------------------------------------------------------

function CAghanim:HealingFilter( filterTable )
	return true
end

---------------------------------------------------------------------------
--	DamageFilter
--  *entindex_victim_const
--	*entindex_attacker_const
--	*entindex_inflictor_const
--	*damagetype_const
--	*damage
---------------------------------------------------------------------------

function CAghanim:DamageFilter( filterTable )
	return true
end


---------------------------------------------------------------------------
--	ItemAddedToInventoryFilter
--  *item_entindex_const
--	*item_parent_entindex_const
--	*inventory_parent_entindex_const
--	*suggested_slot
---------------------------------------------------------------------------

function CAghanim:ItemAddedToInventoryFilter( filterTable )
	return true
end


---------------------------------------------------------------------------
--	ModifierGainedFilter
--  *entindex_parent_const
--	*entindex_ability_const
--	*entindex_caster_const
--	*name_const
--	*duration
---------------------------------------------------------------------------

function CAghanim:ModifierGainedFilter( filterTable )
	if filterTable["entindex_parent_const"] == nil then 
		return true
	end

 	if filterTable[ "name_const" ] == nil then
		return true
	end

	local BlackListModiifers = 
	{
		"modifier_sheepstick_debuff",
		"modifier_stunned",
		"modifier_bashed",
		"modifier_aghsfort_tusk_walrus_punch_air_time",
	}

	local hParent = EntIndexToHScript( filterTable[ "entindex_parent_const" ] )
	if hParent ~= nil and hParent.bAbsoluteNoCC ~= nil and hParent.bAbsoluteNoCC == true then
		local bModifierInBlacklist = false
		for _,szModifierName in pairs ( BlackListModiifers ) do
			if szModifierName == filterTable[ "name_const" ] then
				bModifierInBlacklist = true
				break
			end
		end
		if bModifierInBlacklist then
			local vMaxs = hParent:GetBoundingMaxs()
			local vMins = hParent:GetBoundingMins()
			local flFXScale = ( vMaxs.z - vMins.z / 1.5 )

			local nFxIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/disable_resist.vpcf", PATTACH_CUSTOMORIGIN, hParent )
			ParticleManager:SetParticleControlEnt( nFxIndex, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( nFxIndex, 1, Vector( flFXScale, flFXScale, flFXScale ) )
			ParticleManager:ReleaseParticleIndex( nFxIndex )

			EmitSoundOn( "DisableResistance.EarlyDebuffEnd", hParent )
			return false
		end

		return true
	end

	return true
end
