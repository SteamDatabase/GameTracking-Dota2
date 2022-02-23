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
	if filterTable[ "item_entindex_const" ] == nil or filterTable[ "inventory_parent_entindex_const" ] == nil then 
		return true
	end
	
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
		"modifier_aghsfort_mars_spear_stun",
		"modifier_aghsfort_luna_moon_glaive_knockback",
		"modifier_aghsfort_dawnbreaker_fire_wreath_smash_stun",
		"modifier_aghsfort_void_spirit_aether_remnant_pull",
		"modifier_tidehunter_ravage",
		"modifier_aghsfort_ravage_potion",
	}



	local hParent = EntIndexToHScript( filterTable[ "entindex_parent_const" ] )
	if hParent == nil then 
		return 
	end

	if hParent:IsRealHero() and filterTable[ "name_const" ] == "modifier_dark_willow_debuff_fear" then 
		local flDuration = filterTable[ "duration" ]
		if flDuration > 0 and filterTable[ "entindex_caster_const" ] and filterTable[ "entindex_ability_const" ] then
			local hAbility = EntIndexToHScript( filterTable[ "entindex_ability_const" ] )
			local hCaster = EntIndexToHScript( filterTable[ "entindex_caster_const" ] )
			if hAbility and hCaster then 
				hParent:AddNewModifier( hCaster, hAbility, "modifier_boss_dark_willow_fear_movement_speed", { duration = flDuration } )
				hParent:AddNewModifier( hCaster, hAbility, "modifier_nevermore_requiem_fear", { duration = flDuration } )
				return false
			end
		end
	end

	if hParent.bAbsoluteNoCC ~= nil and hParent.bAbsoluteNoCC == true then
		if hParent.bNoNullifier ~= nil and hParent.bNoNullifier == true then
			table.insert( BlackListModiifers, "modifier_item_nullifier_mute" ) 
			table.insert( BlackListModiifers, "modifier_item_nullifier_slow" ) 
		end

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

--------------------------------------------------------------------------------

function CAghanim:FilterModifyGold( filterTable )
	--printf( "FilterModifyGold, reason: %d, gold %d", filterTable[ "reason_const" ], filterTable[ "gold" ] )

	-- Spend-gold reasons
	if filterTable[ "reason_const" ] == DOTA_ModifyGold_Death or
		filterTable[ "reason_const" ] == DOTA_ModifyGold_Buyback or
		filterTable[ "reason_const" ] == DOTA_ModifyGold_PurchaseConsumable or
		filterTable[ "reason_const" ] == DOTA_ModifyGold_PurchaseItem or
		filterTable[ "reason_const" ] == DOTA_ModifyGold_AbilityCost or
		
		-- incomes that should not be affected
		filterTable[ "reason_const" ] == DOTA_ModifyGold_SellItem or
		filterTable[ "reason_const" ] == DOTA_ModifyGold_CheatCommand then
		return true
	end

	local Hero = PlayerResource:GetSelectedHeroEntity( filterTable[ "player_id_const" ] )
	--printf( "  $$Hero: %s", Hero:GetUnitName() )
	local hBuff = Hero:FindModifierByName( "modifier_event_slark_greed" )

	if hBuff ~= nil then
		--printf( "$$    %s has modifier modifier_event_slark_greed with multiplier %f thus gaining %d extra gold", Hero:GetUnitName(), hBuff.flGoldMultiplier, math.floor( filterTable[ "gold" ] * ( hBuff.flGoldMultiplier - 1.0 ) ) )
		filterTable[ "gold" ] = math.floor( filterTable[ "gold" ] * hBuff.flGoldMultiplier + 0.5 )
		--printf( "$$   value now %d", filterTable[ "gold" ] )
	end

	return true
end

--------------------------------------------------------------------------------
