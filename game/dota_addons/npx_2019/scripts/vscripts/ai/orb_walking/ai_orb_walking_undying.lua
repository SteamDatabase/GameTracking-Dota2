--------------------------------------------------------------------------------

if COrbWalkingUndyingBot == nil then
	COrbWalkingUndyingBot = class({})
end

--------------------------------------------------------------------------------

function COrbWalkingUndyingBot:constructor( me )
	self.me = me
	
	self.nPath = 0
	self.szPath = tostring(nPath)
	self.szPathName = ""
	self.hRetreatMoveLoc = Entities:FindByName( nil, "enemy_location_1" )

	self.bUsedFaerieFire = false

	printf( "UndyingBot::constructor" )
end

--------------------------------------------------------------------------------

function COrbWalkingUndyingBot:BotThink()
	if not IsServer() then
		return
	end

	if self.bWasKilled then
		return -1
	end

	if ( not self.me:IsAlive() ) then
		self.bWasKilled = true
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if self.me:GetHealth() < ( self.me:GetMaxHealth() * 0.25 ) then
		if self.bUsedFaerieFire == false then
			self:Heal()
		end
	end

	if self.hRetreatMoveLoc then
		self:Retreat()
		local vAbsOrigin = self.me:GetAbsOrigin()
		if ( vAbsOrigin - self.hRetreatMoveLoc:GetAbsOrigin() ):Length2D() <= 128 then
			self:GetNextPath()
		end
	end

	return 0.1
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "UndyingThink", UndyingThink, 0.1 )

		thisEntity.Bot = COrbWalkingUndyingBot( thisEntity )
	end
end

--------------------------------------------------------------------------------

function UndyingThink()
	if IsServer() == false then
		return -1
	end

	return thisEntity.Bot:BotThink()
end

--------------------------------------------------------------------------------

function COrbWalkingUndyingBot:GetNextPath()
	self.nPath = self.nPath + 1
	self.szPath = tostring( self.nPath )
	self.szPathName = "enemy_retreat_path"..self.szPath
	self.hRetreatMoveLoc = Entities:FindByName( nil, self.szPathName )
	--print( self.szPathName )
end

--------------------------------------------------------------------------------

function COrbWalkingUndyingBot:Retreat()
	ExecuteOrderFromTable( {
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.hRetreatMoveLoc:GetAbsOrigin(),
		Queue = true,
	} )
end

--------------------------------------------------------------------------------

function COrbWalkingUndyingBot:Heal()
	--print( "Healing" )
	for i = 0, 5 do
		local item = self.me:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_faerie_fire" then
			--print( "Faerie Fire Found" )
			self.faerieFireAbility = item
		end
	end
	if self.faerieFireAbility then
		--print( "Using Faerie Fire" )
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.faerieFireAbility:entindex(),
		} )
		self.bUsedFaerieFire = true
	end
end

--------------------------------------------------------------------------------
