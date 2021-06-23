if hero_meteor_shard_pouch == nil then
	hero_meteor_shard_pouch = class({})
end

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_hero_meteor_shard_pouch", "modifiers/gameplay/modifier_hero_meteor_shard_pouch", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_meteor_shard_pouch_buff", "modifiers/gameplay/modifier_hero_meteor_shard_pouch_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_meteor_shard_pouch_stack", "modifiers/gameplay/modifier_hero_meteor_shard_pouch_stack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:IsStealable()
	return false
end

--------------------------------------------------------------------------------

--[[function hero_meteor_shard_pouch:GetIntrinsicModifierName()
	return "modifier_hero_meteor_shard_pouch"
end--]]

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:GetShardCount()
	--[[local nCharges = self:GetCurrentAbilityCharges()
	if nCharges > 9998 then -- will detect the default of 9999
		nCharges = 0
	end
	return nCharges--]]

	local hBuffs = self:GetCaster():FindAllModifiersByName( "modifier_hero_meteor_shard_pouch_stack" )
	return #hBuffs
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:AddShard( flDuration, nTeamNumber )
	--printf( "Adding a shard of duration %f to %s", ( flDuration or -10000 ), self:GetCaster():GetUnitName() )
	local hBuff = nil
	if flDuration ~= nil then
		hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hero_meteor_shard_pouch_stack", { duration = flDuration } )
		local flHeal = self:GetSpecialValueFor( "health_pct_heal_on_pickup" ) / 100 * self:GetCaster():GetMaxHealth()
		if flHeal > 0 then
			self:GetCaster():Heal( flHeal, self )
		end
		local flManaRestore = self:GetSpecialValueFor( "mana_pct_restore_on_pickup" ) / 100 * self:GetCaster():GetMaxMana()
		if flManaRestore > 0 then
			self:GetCaster():GiveMana( flManaRestore )
		end
	else
		hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hero_meteor_shard_pouch_stack", {} )
	end

	-- Record team number. If there is one (it's not a fresh shard) and it is not our team number, then set it to -1
	-- i.e. no longer allow credit to be given when picked up by the enemy, since they already got credit.
	if nTeamNumber ~= nil and nTeamNumber ~= self:GetCaster():GetTeamNumber() then
		nTeamNumber = -1
	end
	hBuff.nTeamNumber = nTeamNumber

	self:UpdateStats( flDuration )
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:RemoveShard()
	-- TODO: Do we care which one we remove?
	local hBuffs = self:GetCaster():FindAllModifiersByName( "modifier_hero_meteor_shard_pouch_stack" )
	ScriptAssert( #hBuffs > 0, "Tried to remove meteor energy when no stack modifiers!" )
	--printf( "Removing a shard from %s, prev count %d", self:GetCaster():GetUnitName(), #hBuffs )

	-- Tell the buff not to phone home (to gamerules to register the decay, and here to update stats)
	hBuffs[1].bDoNotNotifyOnDestroy = true
	hBuffs[1]:Destroy()
	-- So manually update stats.
	self:UpdateStats()
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:Precache( context )
	PrecacheResource( "particle", "particles/gameplay/moon_juice_overhead/moon_juice_overhead.vpcf", context )
	--CustomNetTables:SetTableValue( "candy_channel_time", string.format( "player_id_%d", self:GetCaster():GetPlayerOwnerID() ), { candy_channel_time = 0.0 } )
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:CastFilterResultTarget( hTarget )
	return UF_SUCCESS
end

-----------------------------------------------------------------------------

function hero_meteor_shard_pouch:OnSpellStart()
	if IsServer() then
	
	end
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:OnChargeCountChanged()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:OnOwnerDied()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function hero_meteor_shard_pouch:UpdateStats( flDuration )
	if IsServer() == false then
		return
	end
	if self:GetCaster():IsHero() == false and ( self:GetCaster():IsCreepHero() == false or self:GetCaster():IsOwnedByAnyPlayer() == false ) then
		return
	end

	local nShards = self:GetShardCount()
	--printf("Ability: Update Stats, shards: %d", nShards )
	local hBuff = self:GetCaster():FindModifierByName( "modifier_hero_meteor_shard_pouch_buff" )
	if nShards > 0 then
		if hBuff == nil or hBuff:IsNull() == true then
			ScriptAssert( flDuration and flDuration > 0, "Tried to create meteor energy buff from a shard add with nil duration!" )
			hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hero_meteor_shard_pouch_buff", { duration = flDuration } )
		else
			if flDuration ~= nil and hBuff:GetRemainingTime() < flDuration then
				hBuff:SetDuration( flDuration, true )
			end
		end
		hBuff:SetStackCount( nShards )
	else
		if hBuff ~= nil and hBuff:IsNull() == false then
			hBuff:Destroy()
		end
	end

	-- for client-side code
	local hIntrinsicBuff = self:GetCaster():FindModifierByName( "modifier_hero_meteor_shard_pouch_buff")
	if hIntrinsicBuff ~= nil and hIntrinsicBuff:IsNull() == false then
		hIntrinsicBuff:SetStackCount( nShards )
	end
end

--------------------------------------------------------------------------------
