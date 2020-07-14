
--print( "fire_trap_cycle_shuffle" )

---------------------------------------------------------------------------
-- Fire Trap Cycle Shuffle
---------------------------------------------------------------------------
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	-- Determine the type of trap
	-- If any one type is weighted we can insert more entries into the table
	thisEntity.hTrapTable = { "standard", "standard", "standard", "tripleshot", "alternating" }
	local nRandomType = RandomInt( 1,5 ) -- Change this number to correspond to the trap table entries
	thisEntity.szTrapType = thisEntity.hTrapTable[nRandomType]
	thisEntity.hRefireTable = { 1.5, 2.0, 2.5, 3.9 }
	thisEntity.nQuickRefires = 0
	thisEntity.bNextAttackIsNormal = false
	thisEntity.fRefireTime = 1.5
	thisEntity.fQuickRefireTime = 0.5

	if thisEntity.szTrapType == "standard" then
		--print("Standard Trap")
		local nRandomRefireTime = RandomInt( 1,4 )
		thisEntity.fRefireTime = thisEntity.hRefireTable[ nRandomRefireTime ]
		--print( "Refire time = " .. thisEntity.fRefireTime )
	elseif thisEntity.szTrapType == "tripleshot" then
		--print("Triple Shot Trap")
		thisEntity.fRefireTime = 2.0
		--print( "Refire time = " .. thisEntity.fRefireTime )
	elseif thisEntity.szTrapType == "alternating" then
		--print("Alternating Trap")
		thisEntity.fRefireTime = 1.8
		--print( "Refire time = " .. thisEntity.fRefireTime )
	end
end


function OnTrigger( trigger )
	EmitGlobalSound( "ui.ui_player_disconnected" )
	EmitSoundOn( "AghanimsFortress.FireTrap", hTrigger )

	thisEntity.hBreatheFireAbility = thisEntity:FindAbilityByName( "breathe_fire" )
	if thisEntity.hBreatheFireAbility == nil then
		print( "ERROR: thisEntity.hBreatheFireAbility not found" )
		return
	end

	if thisEntity.szTrapType == "standard" then
		-- Standard
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fRefireTime

		thisEntity:SetContextThink( "FireTrapActivate", function() return FireTrapActivate() end, 0 )
	elseif thisEntity.szTrapType == "tripleshot" then
		-- TripleShot
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fQuickRefireTime

		thisEntity:SetContextThink( "FireTrapActivateTriple", function() return FireTrapActivateTriple() end, 0 )
	elseif thisEntity.szTrapType == "alternating" then
		-- Alternating
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fQuickRefireTime

		thisEntity:SetContextThink( "FireTrapActivateAlternating", function() return FireTrapActivateAlternating() end, 0 )
	end
end

---------------------------------------------------------------------------

function DisableTrap( trigger )
	thisEntity.bDisabled = true
end

---------------------------------------------------------------------------

function FireTrapActivate()
	if not IsServer() then
		return
	end

	if thisEntity.bDisabled then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if GameRules:GetGameTime() >= thisEntity.fNextAttackTime then
		thisEntity:SetAnimation( "bark_attack" );
		thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fRefireTime
	end

	return 0.5
end

---------------------------------------------------------------------------

function FireTrapActivateTriple()
	if not IsServer() then
		return
	end

	if thisEntity.bDisabled then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if GameRules:GetGameTime() >= thisEntity.fNextAttackTime then
		return QuickRefireTriple()
	end

	return 0.25
end

---------------------------------------------------------------------------

function QuickRefireTriple()
	thisEntity:SetAnimation( "bark_attack" );
	thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

	thisEntity.nQuickRefires = thisEntity.nQuickRefires + 1

	if thisEntity.nQuickRefires <= 2 then
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fQuickRefireTime
	else
		thisEntity.bNextAttackIsNormal = true
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fRefireTime
		thisEntity.nQuickRefires = 0 -- reset counter
	end

	return 0.25
end

---------------------------------------------------------------------------

function FireTrapActivateAlternating()
	if not IsServer() then
		return
	end

	if thisEntity.bDisabled then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if GameRules:GetGameTime() >= thisEntity.fNextAttackTime then
		if thisEntity.bNextAttackIsNormal == false then
			return QuickRefireAlternating()
		else
			return NormalRefire()
		end
	end

	return 0.25
end

---------------------------------------------------------------------------

function QuickRefireAlternating()
	thisEntity:SetAnimation( "bark_attack" );
	thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

	thisEntity.nQuickRefires = thisEntity.nQuickRefires + 1

	if thisEntity.nQuickRefires <= 2 then
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fQuickRefireTime
	else
		thisEntity.bNextAttackIsNormal = true
		thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fRefireTime
		thisEntity.nQuickRefires = 0 -- reset counter
	end

	return 0.25
end

---------------------------------------------------------------------------

function NormalRefire()
	thisEntity:SetAnimation( "bark_attack" );
	thisEntity:CastAbilityOnPosition( thisEntity:GetTrapTarget(), thisEntity.hBreatheFireAbility, -1 )

	thisEntity.fNextAttackTime = GameRules:GetGameTime() + thisEntity.fRefireTime
	thisEntity.bNextAttackIsNormal = false

	return 0.25
end

---------------------------------------------------------------------------

function PickRandomShuffle( reference_list, bucket )
    if ( #reference_list == 0 ) then
        return nil
    end
    
    if ( #bucket == 0 ) then
        -- ran out of options, refill the bucket from the reference
        for k, v in pairs(reference_list) do
            bucket[k] = v
        end
    end

    -- pick a value from the bucket and remove it
    local pick_index = RandomInt( 1, #bucket )
    local result = bucket[ pick_index ]
    table.remove( bucket, pick_index )
    return result
end

---------------------------------------------------------------------------
