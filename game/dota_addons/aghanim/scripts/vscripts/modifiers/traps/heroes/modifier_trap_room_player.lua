
require( "gameplay_shared" )

--------------------------------------------------------------------------------

modifier_trap_room_player = class({})

--------------------------------------------------------------------------------

function modifier_trap_room_player:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:OnCreated( kv )
	if IsServer() then
		self.szTrapRoomAbility = kv[ "trap_room_ability_name" ]

		self:DisableAbilitiesAndItems()

		self:GrantTrapRoomAbility()
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:OnDestroy()
	if IsServer() then
		self:RestoreAbilitiesAndItems()

		self:RemoveTrapRoomAbility()
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:DisableAbilitiesAndItems()
	if IsServer() then
		self.DisabledAbilitiesAndItems = {}

		local AbilitiesAndItems = GetPlayerAbilitiesAndItems( self:GetParent():GetPlayerID() )

		for i = 0, DOTA_MAX_ABILITIES - 1 do
			local hAbility = self:GetParent():GetAbilityByIndex( i )
			if hAbility and not hAbility:IsCosmetic( nil ) and not hAbility:IsAttributeBonus() and hAbility:GetAssociatedPrimaryAbilities() == nil and not hAbility:IsHidden() and hAbility:IsActivated() then
				--printf( "ability to disable: %s", hAbility:GetAbilityName() )
				table.insert( self.DisabledAbilitiesAndItems, hAbility )
			end
		end

		for i = 0, DOTA_ITEM_NEUTRAL_SLOT do
			local hItem = self:GetParent():GetItemInSlot( i )
			if hItem then
				hItem:OnUnequip()
				table.insert( self.DisabledAbilitiesAndItems, hItem )
			end
		end

		for nIndex, hAbilityOrItem in pairs( self.DisabledAbilitiesAndItems ) do
			--printf( "disabling %s", hAbilityOrItem:GetAbilityName() )
			if hAbilityOrItem:GetToggleState() then
				--print( "toggling ability off" )
				hAbilityOrItem:OnToggle()
			end

			hAbilityOrItem:SetActivated( false )
			hAbilityOrItem:SetHidden( true )
			hAbilityOrItem.nOriginalIndex = hAbilityOrItem:GetAbilityIndex()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:GrantTrapRoomAbility()
	self.hTrapRoomAbility = self:GetParent():AddAbility( self.szTrapRoomAbility )
	--printf( "attempting to grant ability %s to player id %d", self.szTrapRoomAbility, self:GetParent():GetPlayerID() )
	if self.hTrapRoomAbility then
		-- Grants and upgrades the ability
		--printf( "  granting %s ability %s", self:GetParent():GetUnitName(), self.hTrapRoomAbility:GetAbilityName() )
		self.hTrapRoomAbility:UpgradeAbility( false )

		self.hFirstSlotAbility = self:GetParent():GetAbilityByIndex( 0 )
		if self.hFirstSlotAbility then
			--printf( "swap first slot ability with %s", self.szTrapRoomAbility )
			self:GetParent():SwapAbilities( self.hFirstSlotAbility:GetAbilityName(), self.hTrapRoomAbility:GetAbilityName(), false, true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:RestoreAbilitiesAndItems()
	if IsServer() then
		for nIndex, hAbilityOrItem in pairs( self.DisabledAbilitiesAndItems ) do
			if hAbilityOrItem ~= nil and hAbilityOrItem:IsNull() == false then
				hAbilityOrItem:SetActivated( true )
				hAbilityOrItem:SetHidden( false )

				if hAbilityOrItem:IsItem() then
					local nSlot = hAbilityOrItem:GetItemSlot()
					if nSlot <= DOTA_ITEM_SLOT_6 or nSlot == DOTA_ITEM_TP_SCROLL or nSlot == DOTA_ITEM_NEUTRAL_SLOT then
						hAbilityOrItem:OnEquip()
					end
				end

				if hAbilityOrItem.nOriginalIndex ~= 0 then
					self:GetParent():RemoveAbilityFromIndexByName( hAbilityOrItem:GetAbilityName() )
					self:GetParent():SetAbilityByIndex( hAbilityOrItem, hAbilityOrItem.nOriginalIndex )
				else
					-- Do something special for first index slot (the Q ability)
					if self.hTrapRoomAbility then
						self:GetParent():SwapAbilities( hAbilityOrItem:GetAbilityName(), self.hTrapRoomAbility:GetAbilityName(), true, false )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:RemoveTrapRoomAbility()
	if self.hTrapRoomAbility then
		self:GetParent():RemoveAbility( self.hTrapRoomAbility:GetAbilityName() )
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_player:CheckState()
	local state =
	{
		[ MODIFIER_STATE_MUTED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
