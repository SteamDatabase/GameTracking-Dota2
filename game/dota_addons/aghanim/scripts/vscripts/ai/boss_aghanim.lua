require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CBossAghanim == nil then
	CBossAghanim = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Precache( context )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossAghanim( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CBossAghanim:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bDefeated = false

	self.ATTACKS_BETWEEN_TELEPORT = 3
	self.ENRAGE_LESS_ATTACKS_BETWEEN_TELEPORT = 1
	self.nCurrentAttacksBetweenTeleport = self.ATTACKS_BETWEEN_TELEPORT
	
	self.PHASE_CRYSTAL_ATTACK = 1
	self.PHASE_STAFF_BEAMS = 2
	self.PHASE_SUMMON_PORTALS = 3
	self.PHASE_SPELL_SWAP = 4
	self.PHASE_SHARD_ATTACK = 5

	self.nSpellSwapPct = 75
	self.bSpellSwapEnabled = false
	self.nShardAttackPct = 40
	self.bShardAttackEnabled = false
	self.nLevelUpPct = 50
	self.bHasLeveledUp = false

	self.AllowedPhases = 
	{
		self.PHASE_CRYSTAL_ATTACK,
		self.PHASE_SUMMON_PORTALS,
		self.PHASE_STAFF_BEAMS,
	}

	self.flInitialAcquireRange = 5000
	self.flAggroAcquireRange = 5000
	self.nPhaseIndex = 1
	self.nNumAttacksBeforeTeleport = self.nCurrentAttacksBetweenTeleport
	self.bReturnHome = true
	self.vLastBlinkLocation = Vector( -3328, 3264, 0 )

	self.me:SetThink( "OnBossAghanimThink", self, "OnBossAghanimThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossAghanim:GetCurrentPhase()
	return self.AllowedPhases[ self.nPhaseIndex ]
end

--------------------------------------------------------------------------------


function CBossAghanim:SetEncounter( hEncounter )
	CBossBase.SetEncounter( self, hEncounter )

	self.TeleportPositions = {}

	local TeleportPositions = hEncounter:GetRoom():FindAllEntitiesInRoomByName( "teleport_position" )
	for _,hEnt in pairs ( TeleportPositions ) do
		table.insert( self.TeleportPositions, hEnt:GetAbsOrigin() )
	end

	local TeleportPositionMain = hEncounter:GetRoom():FindAllEntitiesInRoomByName( "teleport_position_main" )
	if #TeleportPositionMain > 0 then
		self.TeleportPositionMain = TeleportPositionMain[1]
		self.me.vHomePosition = self.TeleportPositionMain:GetAbsOrigin()
		
		table.insert( self.TeleportPositions, self.me.vHomePosition )
	end
end

--------------------------------------------------------------------------------

function CBossAghanim:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hBlink = self.me:FindAbilityByName( "aghanim_blink" )
	if self.hBlink ~= nil then
		self.hBlink.Evaluate = self.EvaluateBlink
	 	self.AbilityPriority[ self.hBlink:GetAbilityName() ] = 5
	end
	
	self.hCrystalAttack = self.me:FindAbilityByName( "aghanim_crystal_attack" )
	if self.hCrystalAttack ~= nil then
		self.hCrystalAttack.nCrystalAttackPhase = 1 
		self.hCrystalAttack.hLastCrystalTarget = nil
		self.hCrystalAttack.Evaluate = self.EvaluateCrystalAttack
	 	self.AbilityPriority[ self.hCrystalAttack:GetAbilityName() ] = 4
	end

	self.hStaffBeams = self.me:FindAbilityByName( "aghanim_staff_beams" )
	if self.hStaffBeams ~= nil then
		self.hStaffBeams.Evaluate = self.EvaluateStaffBeams
	 	self.AbilityPriority[ self.hStaffBeams:GetAbilityName() ] = 3
	end

	self.hSummonPortals = self.me:FindAbilityByName( "aghanim_summon_portals" )
	if self.hSummonPortals ~= nil then
		self.hSummonPortals.Evaluate = self.EvaluateSummonPortals
	 	self.AbilityPriority[ self.hSummonPortals:GetAbilityName() ] = 2
	end

	self.hSpellSwap = self.me:FindAbilityByName( "aghanim_spell_swap" )
	if self.hSpellSwap ~= nil then
		self.hSpellSwap.Evaluate = self.EvaluateSpellSwap
	 	self.AbilityPriority[ self.hSpellSwap:GetAbilityName() ] = 1
	end

	self.hShardAttack = self.me:FindAbilityByName( "aghanim_shard_attack" )
	if self.hShardAttack ~= nil then
		self.hShardAttack.Evaluate = self.EvaluateShardAttack
	 	self.AbilityPriority[ self.hShardAttack:GetAbilityName() ] = 1
	end
end
--------------------------------------------------------------------------------
 
function CBossAghanim:OnBossAghanimThink()
	if self.bDefeated then
		return -1
	end

	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossAghanim:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossAghanim:ChangePhase()
	self.nNumAttacksBeforeTeleport = self.nNumAttacksBeforeTeleport - 1
	--print ( "Aghanim is changing phase! old:" .. self:GetCurrentPhase() )
	if self.nPhaseIndex == #self.AllowedPhases then
		self.nPhaseIndex = 1
	else
		self.nPhaseIndex = self.nPhaseIndex + 1
	end

	self.nPhase = self.AllowedPhases[ self.nPhaseIndex ]
	if self.nPhase == self.PHASE_SHARD_ATTACK then
		self.nNumAttacksBeforeTeleport = 0
		self.bReturnHome = true
	end
end

--------------------------------------------------------------------------------

function CBossAghanim:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if nPct < self.nSpellSwapPct and self.bSpellSwapEnabled == false then
		self.nCurrentAttacksBetweenTeleport = math.max( 1, self.nCurrentAttacksBetweenTeleport - self.ENRAGE_LESS_ATTACKS_BETWEEN_TELEPORT )
		self.bSpellSwapEnabled = true
		self.AllowedPhases = 
		{
			self.PHASE_SPELL_SWAP,
			self.PHASE_SUMMON_PORTALS,
			self.PHASE_STAFF_BEAMS,
			self.PHASE_CRYSTAL_ATTACK,
		}

		self.nPhaseIndex = #self.AllowedPhases
		self:ChangePhase()

		self.nNumAttacksBeforeTeleport = 0
		self.bReturnHome = true
	end

	if nPct < self.nLevelUpPct and self.bHasLeveledUp == false then
		self.bHasLeveledUp = true
		self.me:CreatureLevelUp( 1 )
	end
	

	if nPct < self.nShardAttackPct and self.bShardAttackEnabled == false then
		self.nCurrentAttacksBetweenTeleport = math.max( 1, self.nCurrentAttacksBetweenTeleport - self.ENRAGE_LESS_ATTACKS_BETWEEN_TELEPORT )
		self.bShardAttackEnabled = true
		self.AllowedPhases = 
		{
			self.PHASE_SHARD_ATTACK,
			self.PHASE_STAFF_BEAMS,
			self.PHASE_CRYSTAL_ATTACK,
			self.PHASE_SPELL_SWAP,
			self.PHASE_SUMMON_PORTALS,
		}

		self.nPhaseIndex = #self.AllowedPhases
		self:ChangePhase()

		self.nNumAttacksBeforeTeleport = 0
		self.bReturnHome = true
	end
end

--------------------------------------------------------------------------------

function CBossAghanim:EvaluateCrystalAttack()
	if self:GetCurrentPhase() ~= self.PHASE_CRYSTAL_ATTACK then
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local Order = nil
	if Enemies == nil or #Enemies == 0 then
		return Order
	end

	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = Enemies[ #Enemies ]:GetAbsOrigin(),
		AbilityIndex = self.hCrystalAttack:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hCrystalAttack )
	self.hCrystalAttack.hLastCrystalTarget = Enemies[#Enemies]
	
	return Order
end

--------------------------------------------------------------------------------

function CBossAghanim:EvaluateStaffBeams()
	if self:GetCurrentPhase() ~= self.PHASE_STAFF_BEAMS then
		return nil
	end

	local vTargetPos = self.me.vHomePosition 
	if vTargetPos == self.vLastBlinkLocation then
		local hEnemies = GetEnemyHeroesInRange( self.me, 5000 )
		if #hEnemies > 0 then
			vTargetPos = hEnemies[#hEnemies]:GetAbsOrigin()
		end
	end

	local Order = nil
	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = self.hStaffBeams:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hStaffBeams ) + self.hStaffBeams:GetChannelTime()
	
	return Order
end


--------------------------------------------------------------------------------

function CBossAghanim:EvaluateBlink()
	if self.nNumAttacksBeforeTeleport > 0 then
		return nil
	end

	if self.bReturnHome == true and self.vLastBlinkLocation == self.me.vHomePosition then
		self.nNumAttacksBeforeTeleport = self.nCurrentAttacksBetweenTeleport
		self.bReturnHome = false
		return nil
	end

	local vTeleportLocations = shallowcopy( self.TeleportPositions )
	for k,v in pairs ( vTeleportLocations ) do
		if v == self.vLastBlinkLocation then
			table.remove( vTeleportLocations, k )
			break
		end
	end

	local vPos = nil
	if self.bReturnHome == true then
		vPos = self.me.vHomePosition
	else
		if self:GetCurrentPhase() == self.PHASE_SUMMON_PORTALS then
			local hEnemies = GetEnemyHeroesInRange( self.me, 5000 )
			if #hEnemies > 0 then
				local vFarthestEnemyPos = hEnemies[#hEnemies]:GetAbsOrigin()
				local vClosestPosToEnemy = nil
				local flShortestDist = 99999
				for _,vTeleportPos in pairs ( vTeleportLocations ) do
					local flDistToEnemy = ( vTeleportPos - vFarthestEnemyPos ):Length2D()
					if flDistToEnemy < flShortestDist then
						flShortestDist = flDistToEnemy
						vClosestPosToEnemy = vTeleportPos
					end
				end

				if vTeleportPos ~= nil then
					vPos = vClosestPosToEnemy
				end
			end
		end

		if vPos == nil then
			vPos = vTeleportLocations[ RandomInt( 1, #vTeleportLocations ) ]
		end
	end

	if vPos == nil then
		return nil
	end

	self.vLastBlinkLocation = vPos

	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPos,
		AbilityIndex = self.hBlink:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = 3.0

	return Order
end

--------------------------------------------------------------------------------

function CBossAghanim:EvaluateSummonPortals()
	if self:GetCurrentPhase() ~= self.PHASE_SUMMON_PORTALS then
		return nil
	end

	local vTarget = self.me.vHomePosition
	local hEnemies = GetEnemyHeroesInRange( self.me, 5000 )
	if #hEnemies > 0 and self.vLastBlinkLocation == self.me.vHomePosition then
		vTarget = hEnemies[ 1 ]:GetAbsOrigin()
	end

	local Order = nil
	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTarget,
		AbilityIndex = self.hSummonPortals:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hSummonPortals ) + self.hSummonPortals:GetChannelTime()
	
	return Order
end

--------------------------------------------------------------------------------

function CBossAghanim:EvaluateSpellSwap()
	if self:GetCurrentPhase() ~= self.PHASE_SPELL_SWAP then
		return nil
	end

	local vTargetPos = self.me.vHomePosition 
	if vTargetPos == self.vLastBlinkLocation then
		local hEnemies = GetEnemyHeroesInRange( self.me, 5000 )
		if #hEnemies > 0 then
			vTargetPos = hEnemies[#hEnemies]:GetAbsOrigin()
		end
	end

	local Order = nil
	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = self.hSpellSwap:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hSpellSwap ) + self.hSpellSwap:GetChannelTime()
	
	return Order
end

--------------------------------------------------------------------------------

function CBossAghanim:EvaluateShardAttack()
	if self:GetCurrentPhase() ~= self.PHASE_SHARD_ATTACK then
		return nil
	end

	local Order = nil
	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = self.me.vHomePosition + Vector( 0, -150, 0 ),
		AbilityIndex = self.hShardAttack:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hShardAttack ) + self.hShardAttack:GetChannelTime()
	
	return Order
end


--------------------------------------------------------------------------------

function CBossAghanim:OnBossUsedAbility( szAbilityName )
	if szAbilityName == "aghanim_blink" then
		self.nNumAttacksBeforeTeleport = self.nCurrentAttacksBetweenTeleport
		self.bReturnHome = false
		return
	end

	if szAbilityName == "aghanim_crystal_attack" then
		if self.hCrystalAttack.nPhase == 6 then
			self:ChangePhase()
		end

		return
	end

	self:ChangePhase()
end

