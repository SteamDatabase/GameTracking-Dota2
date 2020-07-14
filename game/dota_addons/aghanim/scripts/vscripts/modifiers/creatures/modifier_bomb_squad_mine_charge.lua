
modifier_bomb_squad_mine_charge = class({})

-------------------------------------------------------

function  modifier_bomb_squad_mine_charge:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:OnCreated( kv )
	if IsServer() then
		self.vTarget = Vector( kv["vLocX"], kv["vLocY"], kv["vLocZ"] )
		self.vDir = self.vTarget - self:GetParent():GetOrigin()
		self.vDir = self.vDir:Normalized()
		self.szMineUnit = "npc_aghsfort_creature_bomb_squad_landmine"
		self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

		self.mine_spawn_interval = self:GetAbility():GetSpecialValueFor( "mine_spawn_interval" )
		self.max_launch_distance = self:GetAbility():GetSpecialValueFor( "max_launch_distance" )
		self.flLastMineTime = GameRules:GetGameTime()
		self:GetParent():StartGesture( ACT_DOTA_RUN )


		self:OnIntervalThink()
		self:StartIntervalThink( 0.33 )
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:OnIntervalThink()
	if IsServer() then
		if GameRules:GetGameTime() - self.flLastMineTime > self.mine_spawn_interval then
			self:SpawnMine()
		end	
		if self:GetParent():IsStunned() == true then
			self:Destroy()
		end

	end
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vNewLocation = self:GetParent():GetOrigin() + self.vDir * self.speed * dt
		me:SetOrigin( vNewLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:SpawnMine()
	if IsServer() then
 		local hUnit = self:GetParent()
 		if hUnit == nil then
 			return
 		end
 		if not hUnit:IsAlive() then
 			return
 		end
		
 		local hMine = CreateUnitByName( self.szMineUnit, self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
 		local nMaxDistance = self.max_launch_distance
 		-- spawn the mine a little bit bit behind us
 		local vLoc = self:GetParent():GetOrigin() - self.vDir * nMaxDistance

		hMine:SetDeathXP( 0 )
		hMine:SetMinimumGoldBounty( 0 )
		hMine:SetMaximumGoldBounty( 0 )

		local kv =
		{
			vLocX = vLoc.x,
			vLocY = vLoc.y,
			vLocZ = vLoc.z,
		}
		hMine:SetAbsAngles( 0 , vLoc.y, 0 )

		hMine:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_frostivus2018_broodbaby_launch", kv )
		self.flLastMineTime = GameRules:GetGameTime()
		EmitSoundOn( "Creature_Bomb_Squad.LandMine.Plant", hMine )
	end

	return
end


--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end


--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveGesture( ACT_DOTA_RUN )
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end


--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:GetModifierDisableTurning(params)
	return 1
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA + 100
end

-----------------------------------------------------------------------------------------

function modifier_bomb_squad_mine_charge:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_FEARED] = false,
	}
	return state
end