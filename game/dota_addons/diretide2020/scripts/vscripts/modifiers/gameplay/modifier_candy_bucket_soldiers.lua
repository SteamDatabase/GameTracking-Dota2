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
		self.bThinking = false

		self.building_hp_buff_pct = kv.building_hp_buff_pct
		self.damage_buff_pct = kv.damage_buff_pct
		self.hp_buff_pct = kv.hp_buff_pct
		self.armor_buff = kv.armor_buff
		self.model_scale = kv.model_scale
		self.soldier_count = kv.soldier_count
		self.is_home = kv.is_home
		if self.is_home == 1 then
			self.bSoldiersInvulnerable = true
		else
			self.bSoldiersInvulnerable = false
		end

		if self.soldier_count > 0 then
			for nSoldiers = 1, self.soldier_count do
				self:CreateSoldier()
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_candy_bucket_soldiers:CreateSoldier()
	if IsServer() == false then
		return
	end

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
		hSoldier.hBucket = self:GetParent()
		table.insert( self.tSoldiers, hSoldier )

		--printf( "modifier_candy_bucket_soldiers:CreateSoldier() - add soldier to my table" )

		local kv =
		{
			damage_buff_pct = self.damage_buff_pct,
			hp_buff_pct = self.hp_buff_pct,
			model_scale = self.model_scale,
			armor_buff = self.armor_buff,
		}
		hSoldier:AddNewModifier( self:GetParent(), nil, "modifier_creature_buff", kv )

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
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
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
					self:StartIntervalThink( DIRETIDE_BUCKET_SOLDIERS_INTERVAL )		
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