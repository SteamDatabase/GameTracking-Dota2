
_G.ENCOUNTER_ABILITY_FUNCTIONS =
{
	ENCOUNTER_START = 
	{		
		--aghsfort_luna_lucent_beam = function( hAbility, hEncounter )
		--	print( hAbility:GetAbilityName() )
		--end,
		modifier_aghsfort_luna_glaive_shield = function( hModifier, hEncounter )
			if hEncounter and 
				(	hEncounter:GetName() == "encounter_bonus_hooking" or 
					hEncounter:GetName() == "encounter_bonus_mango_orchard" or 
					hEncounter:GetName() == "encounter_bonus_smash_chickens" or
					hEncounter:GetName() == "encounter_bonus_gallery" or 
					hEncounter:GetEncounterType() == ROOM_TYPE_TRAPS ) then 
				hModifier:PauseGlaives( true )
			end
		end,

		modifier_item_aghsfort_bloodstone_gainable_charges = function( hModifier, hEncounter )
			if hEncounter:GetEncounterType() == ROOM_TYPE_ENEMY or hEncounter:GetEncounterType() == ROOM_TYPE_BOSS then 
				local nGainableChargesPerRoom = BLOODSTONE_GAINABLE_CHARGES_PER_ROOM
				hModifier:SetStackCount( nGainableChargesPerRoom )
			end
		end,
	},
	
	ENCOUNTER_COMPLETE = 
	{
		--aghsfort_luna_lucent_beam = function( hAbility, hEncounter )
		--	print( hEncounter:GetName() )
		--end,

		modifier_event_ogre_magi_casino_bloodlust = function( hModifier, hEncounter )
			if hEncounter:GetEncounterType() == ROOM_TYPE_ENEMY or hEncounter:GetEncounterType() == ROOM_TYPE_BOSS then 
				hModifier:DecrementStackCount()
				if hModifier:GetStackCount() <= 0 then 
					hModifier:Destroy()
				end
			end
		end,

		modifier_event_leshrac_no_heal = function( hModifier, hEncounter )
			if hEncounter:GetEncounterType() == ROOM_TYPE_ENEMY or hEncounter:GetEncounterType() == ROOM_TYPE_BOSS then 
				hModifier:DecrementStackCount()
				if hModifier:GetStackCount() <= 0 then 
					hModifier:Destroy()
				end
			end
		end,

		modifier_aghsfort_luna_glaive_shield = function( hModifier, hEncounter )
			hModifier:PauseGlaives( false )
		end,
	},
}

