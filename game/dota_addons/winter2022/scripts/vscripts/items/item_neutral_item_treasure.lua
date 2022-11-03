
item_neutral_item_treasure = class({})

--------------------------------------------------------------------------------

function item_neutral_item_treasure:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_neutral_item_treasure:OnSpellStart()
	if IsServer() then
        if self:GetCaster() == nil then
            return
        end

        local nTier = 1
        local fGameTime = GameRules.Winter2022:GetPlayedTime()
        if fGameTime >= ( WINTER2022_NEUTRAL_ITEM_DROP_TIME_TIER_5 * 60 ) then
            nTier = 5
        elseif fGameTime >= ( WINTER2022_NEUTRAL_ITEM_DROP_TIME_TIER_4 * 60 ) then
            nTier = 4
        elseif fGameTime >= ( WINTER2022_NEUTRAL_ITEM_DROP_TIME_TIER_3 * 60 ) then
            nTier = 3
        elseif fGameTime >= ( WINTER2022_NEUTRAL_ITEM_DROP_TIME_TIER_2 * 60 ) then
            nTier = 2
        end
        local szItemDrop = GetPotentialNeutralItemDrop( nTier, self:GetCaster():GetTeamNumber() )
        printf( 'NEUTRAL GREEVIL ITEM TREASURE IS DROPPING NEUTRAL ITEM %s at time %f!', szItemDrop, fGameTime )
        
        -- determine if we can directly put this neutral into our inventory or not
        -- we need either a free backpack slot or a free neutral item slot
        local bAllowPickup = false
        local hNeutralItem = self:GetCaster():GetItemInSlot( DOTA_ITEM_NEUTRAL_SLOT )
        if hNeutralItem == nil then
            bAllowPickup = true
            --print( '^^^Empty neutral slot!' )
        else
            local numBackpackItems = 0
            for nItemSlot = 0,DOTA_ITEM_INVENTORY_SIZE - 1 do 
                local hBackpackItem = self:GetCaster():GetItemInSlot( nItemSlot )
                if hBackpackItem and hBackpackItem:IsInBackpack() then
                    numBackpackItems = numBackpackItems + 1
                end
            end
            --print( '^^^Backpack slots = ' .. numBackpackItems )
            if numBackpackItems < 3 then
                bAllowPickup = true
            end
        end		

        local hItem = nil
        if bAllowPickup then
            print( '^^^inventory has space - attempting to add it directly to the hero' )
            hItem = self:GetCaster():AddItemByName( szItemDrop )
            EmitSoundOn( "NeutralTreasure.Pickup", self:GetCaster() )
        end

        if hItem == nil then
            printf( 'ERROR: COULD NOT ADD NEUTRAL ITEM %s to unit %s!', szItemDrop, self:GetCaster():GetUnitName() )
            printf( 'ATTEMPTING TO PUT IT IN THE NEUTRAL STASH' )
            hItem = CreateItem( szItemDrop, nil, nil )
            if hItem == nil then
                printf( 'ERROR: FAILED TO CREATE ITEM %s ', szItemDrop )
            else
                PlayerResource:AddNeutralItemToStash( self:GetCaster():GetPlayerID(), self:GetCaster():GetTeamNumber(), hItem )
                EmitSoundOn( "NeutralItem.TeleportToStash", self:GetCaster() )
            end
        end


        RecordNeutralItemEarned( self:GetCaster(), hItem, nTier )
		--local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		--ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
