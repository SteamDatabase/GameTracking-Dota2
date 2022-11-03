if modifier_candy_bucket_soldiers == nil then
modifier_candy_bucket_soldiers = class({})
end

------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:OnCreated( kv )
	if IsServer() == true then
		self.tSoldiers = {}
		self.bThinking = true
		self:StartIntervalThink( 1.0 )

		self.building_hp_buff_pct = kv.building_hp_buff_pct
		self.soldier_count = kv.soldier_count
		self.is_home = kv.is_home
		if self.is_home == 1 then
			self.bSoldiersInvulnerable = true
		else
			self.bSoldiersInvulnerable = false
		end
		self.tier = kv.tier
	end
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:CreateSoldier()
	if IsServer() == false then
		return
	end

	if GameRules.Winter2022:IsPrepOrInProgress() == false then
		return
	end

	print( 'CREATING SOLDIER!' )

	local vSpawnPos = self:GetParent():GetAbsOrigin() + RandomVector( 200 )
	local szCreepName = "npc_dota_radiant_bucket_soldier"
	if self:GetParent():GetTeamNumber() == DOTA_TEAM_BADGUYS then
		szCreepName = "npc_dota_dire_bucket_soldier"
	elseif self:GetParent():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		szCreepName = "npc_dota_radiant_bucket_soldier"
	else
		szCreepName = "npc_dota_neutral_bucket_soldier"
	end

	local hSoldier = CreateUnitByName( szCreepName, vSpawnPos, true, nil, nil, self:GetParent():GetTeamNumber() )
	if hSoldier then
		if hSoldier.AI ~= nil then
			--print( '^^^ADDING BUCKET REF TO SOLDIER!' )
			hSoldier.AI.hBucket = self:GetParent()
		end
		table.insert( self.tSoldiers, hSoldier )

		--printf( "modifier_candy_bucket_soldiers:CreateSoldier() - add soldier to my table" )

		-- beef up our golems as we advance through the game - set the tier based off of clock time
		local hDynamicBuff = hSoldier:AddNewModifier( hSoldier, nil, "modifier_creature_buff_dynamic", {} )
		if hDynamicBuff ~= nil then
			if WINTER2022_BUCKET_SOLDIERS_INHERENTLY_BUFF_TIER_TWO == 1 then
				print( '^^^SETTING STACK COUNT ON DYNAMIC GOLEM BUFF TO ' .. self.tier )
				hDynamicBuff:SetStackCount( self.tier )
			end
		end

		if self.bSoldiersInvulnerable == true or self:GetParent():IsInvulnerable() then
			hSoldier:AddNewModifier( self:GetParent(), nil, "modifier_invulnerable", {} )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
		--MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}

	return funcs
end


-----------------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:OnDeath( params )
	if IsServer() then
		if self.bSoldiersInvulnerable == true and params.unit:IsBuilding() == true then
			if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() and params.unit:GetUnitName() == "candy_bucket" then
				for k,Soldier in pairs( self.tSoldiers ) do
					Soldier:RemoveModifierByName( "modifier_invulnerable" )
				end
				self.bSoldiersInvulnerable = false
			end
			return
		end
		for k,Soldier in pairs( self.tSoldiers ) do
			if params.unit == Soldier then
				table.remove( self.tSoldiers, k )
				--[[if self.bThinking == false then
					self.bThinking = true
					self:StartIntervalThink( WINTER2022_BUCKET_SOLDIERS_INTERVAL )		
				end--]]
				break
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:OnIntervalThink()
	if IsServer() == false then
		return
	end

	-- don't create our soldier if we are invuln
	if self:GetParent():IsInvulnerable() then
		return
	end

	self:CreateSoldier()

	if #self.tSoldiers >= self.soldier_count then
		self:StartIntervalThink( -1 )
		self.bThinking = false
	end
end

-----------------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:OnDestroy()
	if IsServer() == false then
		return
	end
	
	for _,Soldier in pairs ( self.tSoldiers ) do 
		if Soldier ~= nil and Soldier:IsNull() == false then
			Soldier:ForceKill( false )
		end
	end
	self.tSoldiers = {}
end

-----------------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:GetModifierExtraHealthPercentage( params )
	if self.building_hp_buff_pct == nil then return 0 end
	return self.building_hp_buff_pct
end

-----------------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:RefreshSoldiers()
	if IsServer() == false then
		return
	end

	for _,hSoldier in pairs ( self.tSoldiers ) do
		if hSoldier ~= nil and hSoldier:IsNull() == false then
			--print( '^^^modifier_candy_bucket_soldiers HEALING soldier to full.' )
			hSoldier:Heal( hSoldier:GetMaxHealth(), hSoldier )
		end
	end

	-- start up our thinker again if we don't have the right amount of soldiers - they'll generate on tick if needed
	if #self.tSoldiers < self.soldier_count then
		--print( '^^^modifier_candy_bucket_soldiers RESTARTING THINK to respawn soldier.' )
		self:StartIntervalThink( 1.0 )
		self.bThinking = true
	end
end

-----------------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:UpdateSoldiers()
	if IsServer() == false then
		return
	end
	
	for _,Soldier in pairs ( self.tSoldiers ) do
		if Soldier ~= nil and Soldier:IsNull() == false then
			if self.bSoldiersInvulnerable == true or self:GetParent():IsInvulnerable() then
				Soldier:AddNewModifier( self:GetParent(), nil, "modifier_invulnerable", {} )
			else
				Soldier:RemoveModifierByName( "modifier_invulnerable" )
			end
		end
	end
end