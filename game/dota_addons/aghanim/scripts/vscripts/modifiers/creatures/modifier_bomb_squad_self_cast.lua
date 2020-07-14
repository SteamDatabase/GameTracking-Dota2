modifier_bomb_squad_self_cast = class({})

require( "utility_functions" ) -- require utility_functions early (other required files may use its functions)
require( "aghanim_utility_functions" ) -- require utility_functions early (other required files may use its functions)
--------------------------------------------------------------------------------

function modifier_bomb_squad_self_cast:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_self_cast:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_self_cast:OnCreated( kv )
	if IsServer() then
		self.hMines = { }
		self.max_active_mines = self:GetAbility():GetSpecialValueFor( "max_active_mines" )
		self.mine_spawn_interval = self:GetAbility():GetSpecialValueFor( "mine_spawn_interval" )
		self.max_launch_distance = self:GetAbility():GetSpecialValueFor( "max_launch_distance" )
		self.flLastMineTime = GameRules:GetGameTime()
		self.flLastOrderTime = GameRules:GetGameTime() - 5
		self.bActivated = false;
		self.szMineUnit = "npc_aghsfort_creature_bomb_squad_landmine"

		self:OnIntervalThink()
	end
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_self_cast:DeclareFunctions()
	local funcs = {
			MODIFIER_EVENT_ON_DEATH,
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end

function modifier_bomb_squad_self_cast:OnIntervalThink()
	if IsServer() then

		if GameRules:GetGameTime() - self.flLastOrderTime > 5 then
			self:DoMove()

		end

		if GameRules:GetGameTime() - self.flLastMineTime > self.mine_spawn_interval then
			self:SpawnMine()
		end	

		if self.bActivated == false then		
			self.bActivated = true
			self:StartIntervalThink( 1 )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_bomb_squad_self_cast:SpawnMine()
	if IsServer() then
 		local hUnit = self:GetParent()
 		if hUnit == nil then
 			return
 		end
 		if not hUnit:IsAlive() then
 			return
 		end

 		if #self.hMines > self.max_active_mines then
 			return
 		end
		
 		local hMine = CreateUnitByName( self.szMineUnit, self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
 		local nMaxDistance = self.max_launch_distance
 		local vLoc = FindPathablePositionNearby(self:GetParent():GetAbsOrigin(), 150, nMaxDistance )
		table.insert( self.hMines, hMine )

		local heroes = FindRealLivingEnemyHeroesInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), FIND_UNITS_EVERYWHERE )
		local hero = heroes[RandomInt(1, #heroes)]
		if hero ~= nil then
			hMine:SetInitialGoalEntity( hero )
		else
			hMine:SetInitialGoalEntity( self:GetParent().hInitialGoalEntity )
		end

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


function modifier_bomb_squad_self_cast:DoMove()
	if IsServer() then

		for i=1,4 do
			local vLoc = FindPathablePositionNearby(self:GetParent():GetAbsOrigin(), 800, 2000 )

			if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then

				ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vLoc,
				Queue = false,
				})
				self.flLastOrderTime = GameRules:GetGameTime()

				break
			end
		end
	end
	return
end	

--------------------------------------------------------------------------------


function modifier_bomb_squad_self_cast:OnDeath( params )
	if IsServer() then
		if TableContainsValue (self.hMines, params.unit) then
			local k = TableFindKey(self.hMines, params.unit)
			params.unit:AddEffects( EF_NODRAW )
			table.remove(self.hMines, k)
		end	
	end
end	

--------------------------------------------------------------------------------