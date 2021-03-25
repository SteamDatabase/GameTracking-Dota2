_G.LAST_HIT_AI_SKILL = 
{
	EASY = 1,
	MEDIUM = 2,
	HARD = 3,
}

_G.LAST_HIT_AI_TYPE =
{
	BALANCED = 1,
	LAST_HIT_FOCUSED = 2,
	DENY_FOCUSED = 3,
	HARASS_FOCUSED = 4,
}

-----------------------------------------------------------------------------------------------------

if CDotaAILaning == nil then
	CDotaAILaning = class({})
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:constructor( eSkill, eType, me )
	self.me = me

	self.flApproachExpire = 0
	self.flActionExpire = 0
	self.hActionTarget = nil
	self.AbilityFuncs = {}
	self.AbilityLearnOrder = {}
	self.CreepDamageInstances = {}
	self.nHarassPctBonus = 0

	self.szCurrentAbilityName = nil

	self:SetLaningSkillAndType( eSkill, eType )

	self.nTakeDamageListener = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CDotaAILaning, "OnTakeDamage" ), self )
	self.nEntityKilledListener = ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDotaAILaning, "OnEntityKilled" ), self )
	self.nTangoUsedListener = ListenToGameEvent( "nommed_tree", Dynamic_Wrap( CDotaAILaning, "OnNommedTree" ), self )
	self.nLevelGainedListenerr = ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CDotaAILaning, "OnPlayerGainedLevel" ), self )
	self.nPlayerUsedAbilityListener = ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( CDotaAILaning, "OnPlayerUsedAbility" ), self )

	ListenToGameEvent( "scenario_restarted", Dynamic_Wrap( CDotaAILaning, "OnScenarioRestarted" ), self )
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:SetLastHitHoverRange( flRange )
	self.flLastHitHoverRange = flRange
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:SetLaningSkillAndType( eSkill, eType )
	self.eSkill = eSkill
	self.eType = eType

	-- LAST_HIT_AI_SKILL.EASY, LAST_HIT_AI_TYPE.BALANCED
	self.nHealthPctDifferentialPct = 75
	self.nHarassPct = 4 
	self.nHarassPctBonusPerAttack = 10
	self.nDenyWeightPct = 15
	self.flLastHitHoverRange = self.me:Script_GetAttackRange() + 300.0

	if self.eSkill == LAST_HIT_AI_SKILL.MEDIUM then
		self.nHealthPctDifferentialPct = 65
		self.nHarassPct = 8
		self.nHarassPctBonusPerAttack = 20
	end
	if self.eSkill == LAST_HIT_AI_SKILL.HARD then
		self.nHealthPctDifferentialPct = 30
		self.nHarassPct = 16
		self.nHarassPctBonusPerAttack = 30
	end

	if self.eType == LAST_HIT_AI_TYPE.HARASS_FOCUSED then
		self.nHealthPctDifferentialPct = self.nHealthPctDifferentialPct / 2
		self.nHarassPct = self.nHarassPct * 2
	end
	if self.eType == LAST_HIT_AI_TYPE.DENY_FOCUSED or self.eType == LAST_HIT_AI_TYPE.LAST_HIT_FOCUSED then
		self.nHealthPctDifferentialPct = self.nHealthPctDifferentialPct * 2
		self.nHarassPct = self.nHarassPct / 2
		if self.eType == LAST_HIT_AI_TYPE.DENY_FOCUSED then
			self.nDenyWeightPct = 35
		else
			self.nDenyWeightPct = 5
		end
	end
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:DoLaning()
	if IsServer() == false then
		return -1
	end

	if self.me == nil or self.me:IsNull()  then
		return -1
	end

	if self.me:IsAlive() == false then
		return 0.25
	end

	if self.szCurrentAbilityName ~= nil then
		return 0.1
	end

	self.Heroes = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, 5000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	self.Creeps = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, 5000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	
	local Towers = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
	for _,hTower in pairs ( Towers ) do
		if hTower and hTower:IsTower() then
			if hTower:GetTeamNumber() == self.me:GetTeamNumber() then
				self.hMyTower = hTower
			else
				self.hEnemyTower = hTower
			end
		end
	end

	local nAlliedCreeps = 0

	self.LastHitTargets = {}
	self.DenyTargets = {}
	self.RangedCreepTargets = {}
	self.CreepsBelow50 = {}

	self.nHarassPctBonus =  math.max( self.nHarassPctBonus - 1, 0 )

	for _,hCreep in pairs ( self.Creeps ) do
		local flRangeToCreep = ( hCreep:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
		local nCreepHP = hCreep:GetHealth()
		local bSameTeam = hCreep:GetTeamNumber() == self.me:GetTeamNumber()
		local flDamageThreshold = self.me:GetAttackDamage() * 2

		if hCreep:GetHealth() < flDamageThreshold then
			if self:ShouldAttemptLastHit( flRangeToCreep, nCreepHP, hCreep:IsRangedAttacker() ) then
				if not bSameTeam then
					table.insert( self.LastHitTargets, hCreep )
				else
					table.insert( self.DenyTargets, hCreep )
				end

				if hCreep:IsRangedAttacker() then
					table.insert( self.RangedCreepTargets, hCreep )
				end
			else
				if hCreep:GetHealthPercent() < 50 then
					if bSameTeam then
						if RollPercentage( self.nDenyWeightPct ) then				
							table.insert( self.DenyTargets, hCreep )
						end
					else
						table.insert( self.CreepsBelow50, hCreep )
					end
				end
			end
		end
		
		if bSameTeam then
			nAlliedCreeps = nAlliedCreeps + 1
		end
	end

	self.AttackTargets = {}
	
	for _,hHero in pairs ( self.Heroes ) do
		if hHero:GetTeamNumber() ~= self.me:GetTeamNumber() then
			if self:ShouldHarassEnemyHero( hHero ) then
				table.insert( self.AttackTargets, hHero )
			end
		end
	end

	local flEvaluateCreepAggro = self:UpdateCreepAggro()
	local flEvaluateItem = self:EvaluateFaerieFire()
	
	local hEnemyHeroToAttack = nil
	if #self.AttackTargets > 0 and RollPercentage( self.nHarassPct + self.nHarassPctBonus ) then
		local hHighestChanceHero = nil
		for _,EnemyHero in pairs ( self.AttackTargets ) do
			if EnemyHero.nChanceToHarass then
				if hHighestChanceHero == nil or EnemyHero.nChanceToHarass > hHighestChanceHero.nChanceToHarass then
					hHighestChanceHero = EnemyHero
				end

				if RollPercentage( EnemyHero.nChanceToHarass ) then
					hEnemyHeroToAttack = EnemyHero
				end
			end 
		end

		if hEnemyHeroToAttack == nil then
			hEnemyHeroToAttack = hHighestChanceHero 
		end
	end
	
	if self.hActionTarget ~= nil then
		if hEnemyHeroToAttack == nil and self.me:CanEntityBeSeenByMyTeam( self.hActionTarget ) and self.flActionExpire >= GameRules:GetGameTime() then
			if flEvaluateItem == -1 then --and not self:ShouldInterruptActionForRangedCreep() then
				return 0.1
			end
		end

		self:InvalidateCurrentAction()
	end

	if flEvaluateItem ~= -1 then
		return flEvaluateItem
	end

	if #self.RangedCreepTargets == 0 then
		local flEvaluateItem = self:EvaluateSalve()
		if flEvaluateItem ~= -1 then
			return flEvaluateItem
		end

		local flEvaluateItem = self:EvaluateTango()
		if flEvaluateItem ~= -1 then
			return flEvaluateItem
		end

		local flEvaluateAbilityThink = self:EvaluateAbilities()
		if flEvaluateAbilityThink ~= -1 then
			return flEvaluateAbilityThink
		end

		if nAlliedCreeps == 0 then
			return self:RetreatToTower()
		end

		if flEvaluateCreepAggro ~= -1 then
			return self:DeAggro()
		end

		if hEnemyHeroToAttack ~= nil then
			return self:HarassEnemyLaner( hEnemyHeroToAttack )
		end
	end
	
	return self:LastHitAndDeny()
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:ShouldInterruptActionForLasthit()
	return self.hActionTarget.bTree == nil  and ( self.hActionTarget:IsRangedAttacker() and self.hActionTarget:IsCreep() or #self.RangedCreepTargets == 0 )
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:SetCastingAbility( szAbilityName, hActionTarget, flTimeToComplete )
	self.szCurrentAbilityName = szAbilityName
	self.hActionTarget = hActionTarget
	self.flActionExpire = GameRules:GetGameTime() + flTimeToComplete
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:InvalidateCurrentAction()
	self.hActionTarget = nil
	self.flActionExpire = GameRules:GetGameTime()
	self.szCurrentAbilityName = nil
	self.flApproachExpire = GameRules:GetGameTime()
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:EvaluateSalve()
	if self.me:GetHealthPercent() < 20 then
		for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
			local hItem = self.me:GetItemInSlot( iSlot )
			if hItem and hItem:GetAbilityName() == "item_flask" then
				return self:UseSalve( hItem )
			end
		end
	end

	return -1
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:EvaluateFaerieFire()
	if self.me:GetHealthPercent() < 10 then
		for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
			local hItem = self.me:GetItemInSlot( iSlot )
			if hItem and hItem:GetAbilityName() == "item_faerie_fire" then
				return self:UseFaerieFire( hItem )
			end
		end
	end
	
	return -1
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:EvaluateTango()
	if self.me:GetHealthPercent() < 40 then
		local hTangoItem = nil
		for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
			local hItem = self.me:GetItemInSlot( iSlot )
			if hItem and hItem:GetAbilityName() == "item_tango" and hItem:IsCooldownReady() and self.me:FindModifierByName( "modifier_tango_heal" ) == nil then
				local Trees = GridNav:GetAllTreesAroundPoint( self.hMyTower:GetOrigin(), 1000, false )
				if #Trees > 0 then
					return self:UseTango( hItem, Trees[1] )
				end
			end
		end
	end

	return -1
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:SetAbilityLearnOrder( hAbilityTable )
	self.AbilityLearnOrder = hAbilityTable

	for i=1,self.me:GetLevel() do
		local szAbilityToLearnName = self.AbilityLearnOrder[ i ]
		if szAbilityToLearnName == nil then
			print( "Nil ability name in Laning AI learn order!" )
			return
		end

		local hAbilityToLearn = self.me:FindAbilityByName( szAbilityToLearnName )
		if hAbilityToLearn == nil then
			print( "Ability " .. szAbilityToLearnName .. " not found!" )
			return
		end

		hAbilityToLearn:UpgradeAbility( true )
	end
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:AddAbilityFunc( szAbilityName, hFunc )
	self.AbilityFuncs[szAbilityName] = hFunc
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:EvaluateAbilities()
	local flAbilityEvaluate = -1
	for _,Func in pairs ( self.AbilityFuncs ) do
		flAbilityEvaluate = Func()
		if flAbilityEvaluate ~= -1 then
			break
		end
	end

	return flAbilityEvaluate
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:ShouldAttemptLastHit( flRange, nHealth, bRanged )
	if flRange > self.flLastHitHoverRange then
		return false
	end

	local nAttackDamage = self.me:GetAttackDamage() -- this is a random sample within the min and max range, for inherent randomness
	local flAttackRange = self.me:Script_GetAttackRange()
	local flDamageBufferMax = nAttackDamage + ( nAttackDamage * flRange / flAttackRange )

	if bRanged then
		flDamageBufferMax = flDamageBufferMax * 1.5 
	end

	if nHealth > flDamageBufferMax then
		return false
	end

	return true
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:ShouldHarassEnemyHero( hHero )
	local flRangeToHero = ( hHero:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
	local nHeroHP = hHero:GetHealth()
	if nHeroHP == 0 then
		return false
	end

	if flRangeToHero > ( self.me:Script_GetAttackRange() + 150 ) then
		return false
	end

	if not self.me:CanEntityBeSeenByMyTeam( hHero ) then
		return false
	end

	if nHeroHP < 100 then
		return true
	end

	local nProximityBonus = 0
	if flRangeToHero > 0 then
		if self.me:IsRangedAttacker() then
			nProximityBonus = self.me:Script_GetAttackRange() / flRangeToHero * self.nHarassPct
		else
			nProximityBonus = 300 / flRangeToHero * self.nHarassPct
		end  
	end

	local nLevelIgnoreBonus = math.min( 3 - self.me:GetLevel() * 20, 0 )
	local nLevelDifferentialBonus = math.min( hHero:GetLevel() - self.me:GetLevel() * 20, 0 )
	local bIsTargetHighGround = self.me:GetAbsOrigin().z < hHero:GetAbsOrigin().z
	local nChanceToIgnore = math.max( ( #self.CreepsBelow50 * 10 ) + nLevelIgnoreBonus + nLevelDifferentialBonus - self.nHarassPctBonus - nProximityBonus, 0 )
	if bIsTargetHighGround then
		nChanceToIgnore = nChanceToIgnore * 2 
	end

	if RollPercentage( nChanceToIgnore ) then
		return false
	end

	hHero.nChanceToHarass = 100 - nChanceToIgnore
	return true
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:ShouldUseAbility( hAbility, hHero )
	return false
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:LastHitAndDeny()
	if #self.RangedCreepTargets > 0 then
		return self:AttackCreep( self.RangedCreepTargets[1] )
	end

	if #self.DenyTargets == 0 and #self.LastHitTargets == 0 then
		return self:ApproachLastHittingDistance()
	end

	if #self.DenyTargets == 0 then
		return self:AttackCreep( self.LastHitTargets[ RandomInt( 1, #self.LastHitTargets ) ] )
	end

	if #self.LastHitTargets == 0 then
		return self:AttackCreep( self.DenyTargets[ RandomInt( 1, #self.DenyTargets ) ] )
	end

	local nTotalTargets = #self.LastHitTargets + #self.DenyTargets
	local flRollDenyPct = #self.DenyTargets * self.nDenyWeightPct / nTotalTargets
	if RollPercentage( math.ceil( flRollDenyPct ) ) then
		return self:AttackCreep( self.DenyTargets[1] )
	end

	return self:AttackCreep( self.LastHitTargets[1] )
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:HarassEnemyLaner( hTarget )
	return self:AttackHero( hTarget )
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:ApproachLastHittingDistance()
	if self.flApproachExpire > GameRules:GetGameTime() then
		return 0.1
	end

	local vCenter = Vector( 0, 0, 0 )
	local nPoints = 0
	local flDistToMyTower = 0.0

	if self.hMyTower ~= nil then
		--vCenter = vCenter + self.hMyTower:GetAbsOrigin()
		--nPoints = nPoints + 1

		flDistToTower = ( self.hMyTower:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
	end

	for _,hCreep in pairs ( self.Creeps ) do
		local flDistToMe = ( hCreep:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D() 
		if hCreep:GetTeamNumber() == self.me:GetTeamNumber() then
			vCenter = vCenter + hCreep:GetAbsOrigin()
			nPoints = nPoints + 1
			if hCreep:IsRangedAttacker() then
				vCenter = vCenter + hCreep:GetAbsOrigin()
				nPoints = nPoints + 1
			end
		end
	end

	-- Creeps below 50% HP are counted twice
	for _,hCreep in pairs ( self.CreepsBelow50 ) do
		if hCreep:GetTeamNumber() == self.me:GetTeamNumber() then
			vCenter = vCenter + hCreep:GetAbsOrigin()
			nPoints = nPoints + 1
			if hCreep:IsRangedAttacker() then
				vCenter = vCenter + hCreep:GetAbsOrigin()
				nPoints = nPoints + 1
			end
		end
	end


	if nPoints <= 1 then
		return self:RetreatToTower()
	end

	vCenter = vCenter / nPoints
	local vPositionToApproach = vCenter
	
	local vHeroOrigin = Vector( 0, 0, 0 )
	local bFoundHero = false
	local hEnemyHero= nil
	for i=1,#self.Heroes do 
		hEnemyHero = self.Heroes[i]
		if hEnemyHero ~= self.me and hEnemyHero:GetTeamNumber() ~= self.me:GetTeamNumber() and hEnemyHero:IsAlive() and self.me:CanEntityBeSeenByMyTeam( hEnemyHero ) then
			vHeroOrigin = hEnemyHero:GetAbsOrigin()
			bFoundHero = true
			break
		end
	end

	if bFoundHero then
		local vEnemyHeroToCenter = vCenter - vHeroOrigin
		vEnemyHeroToCenter.z = 0.0
		vEnemyHeroToCenter = vEnemyHeroToCenter:Normalized()

		 -- + vEnemyHeroToCenter 
		vPositionToApproach = vPositionToApproach + vEnemyHeroToCenter * RandomInt( 150, 350 )
		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vPositionToApproach, 
		})

		local vToEnemyLaner = vHeroOrigin - self.me:GetAbsOrigin() 
		vToEnemyLaner = vToEnemyLaner:Normalized()
		local vFaceEnemyLaner = vPositionToApproach + vToEnemyLaner * RandomInt( 75, 225 )
		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vFaceEnemyLaner,
			Queue = 1,
		})

		--print ( "ApproachLastHittingDistance Queing ( " .. vFaceEnemyLaner.x .. ", " .. vFaceEnemyLaner.y .. ", " .. vFaceEnemyLaner.z )
	else
		local vToTower = self.hMyTower:GetAbsOrigin() - self.me:GetAbsOrigin()
		vToTower = vToTower:Normalized()

		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vPositionToApproach * vToTower * RandomInt( 0, 150 ), 
		})
	end

	self.flApproachExpire = GameRules:GetGameTime() + RandomFloat( 0.8, 2.2 )
	return 0.1
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:GetRetreatTime()
	if self.hMyTower == nil then
		return 0.0
	end

	local nHealthPercent = self.me:GetHealthPercent()
	local flDistToTower = ( self.hMyTower:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
	if flDistToTower <= 0.0 then
		return 0.0
	end

	local flCurrSpeed = self.me:GetIdealSpeed()
	local flTimeToTower = flCurrSpeed / flDistToTower
	local flRetreatTime = ( flTimeToTower * ( 100 - nHealthPercent ) ) / 100

	return flRetreatTime
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:RetreatToTower()
	local vPositionToApproach = self.hMyTower:GetAbsOrigin() + RandomVector( 1 ) * RandomFloat( 50, 150 )
	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPositionToApproach,
	})
	--DebugDrawCircle( vPositionToApproach, Vector( 255, 0, 0 ), 255, 50, true, 0.25 )
	return self:GetRetreatTime()
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:AttackCreep( hCreep )
	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hCreep:entindex(),
	})

	self.flApproachExpire = GameRules:GetGameTime()
	self.flActionExpire = GameRules:GetGameTime() + self.me:GetAttackAnimationPoint() * 2
	self.hActionTarget = hCreep
	return 0.1
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:AttackHero( hHero )
	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hHero:entindex(),
	})

	self.flApproachExpire = GameRules:GetGameTime()
	self.flActionExpire = GameRules:GetGameTime() + self.me:GetAttackAnimationPoint() * 2
	self.hActionTarget = hHero
	return 0.1
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:UseTango( hTango, hTree )
	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET_TREE,
		TargetIndex = GetTreeIdForEntityIndex( hTree:entindex() ),
		AbilityIndex = hTango:entindex(),
	})

	self.flApproachExpire = GameRules:GetGameTime()
	self.flActionExpire = GameRules:GetGameTime() + 20.0
	self.hActionTarget = hTree
	self.hActionTarget.bTree = true
	return 0.1
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:UseFaerieFire( hFaerieFire )
	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hFaerieFire:entindex(),
	})

	self.flActionExpire = GameRules:GetGameTime() + 10.0
	return self:RetreatToTower()
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:UseSalve( hSalve )
	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hSalve:entindex(),
	})

	self.flActionExpire = GameRules:GetGameTime() + 10.0
	return self:RetreatToTower()
end

--------------------------------------------------------------------------------

function CDotaAILaning:UpdateCreepAggro()
	local flNow = GameRules:GetGameTime()
	local flCreepAggroExpire = 5.0
	for i=#self.CreepDamageInstances,1,-1 do
		local flTimeLimit = flCreepAggroExpire + self.CreepDamageInstances[i]
		if flTimeLimit <= flNow then
			table.remove( self.CreepDamageInstances, i )
		end
	end

	if #self.CreepDamageInstances < 5 then
		return -1
	end

	return #self.CreepDamageInstances
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:DeAggro()
	local hHighestHPHero = nil
	local nHighestHP = 0
	for _,Hero in pairs ( self.Heroes ) do
		if Hero:GetHealth() > nHighestHP then
			nHighestHP = Hero:GetHealth()
			hHighestHPHero = Hero
		end
	end

	local hAlliedCreep = nil
	if hHighestHPHero == self.me or self.me:GetHealthPercent() > 50 then
		for _,Creep in pairs ( self.Creeps ) do
			if Creep:GetTeamNumber() == self.me:GetTeamNumber() then
				hAlliedCreep = Creep
				break
			end
		end
	end

	if hAlliedCreep ~= nil then
		return self:AttackCreep( hAlliedCreep )
	end

	return self:RetreatToTower()
end

-----------------------------------------------------------------------------------------------------

function CDotaAILaning:RespondToHeroAttack()
	self.nHarassPctBonus = self.nHarassPctBonus + self.nHarassPctBonusPerAttack
	self:InvalidateCurrentAction()
end

--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - int
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
-- > damage - float
--------------------------------------------------------------------------------		
function CDotaAILaning:OnTakeDamage( event )
	local hEntVictim = nil
	local hEntAttacker = nil
	if event.entindex_killed == nil or event.entindex_attacker == nil or self.me == nil then
		return
	end

	hEntVictim = EntIndexToHScript( event.entindex_killed )
	hEntAttacker = EntIndexToHScript( event.entindex_attacker )

	local nHealthPct = self.me:GetHealthPercent()
	if hEntVictim == self.me then
		if hEntAttacker then
			if hEntAttacker:IsRealHero() then
				return self:RespondToHeroAttack()
			end
			if hEntAttacker:IsCreep() then
				table.insert( self.CreepDamageInstances, GameRules:GetGameTime() )
				return self:UpdateCreepAggro()
			end
		end
	end
end

--------------------------------------------------------------------------------
-- entity_killed
-- > entindex_killed - int
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
--------------------------------------------------------------------------------
function CDotaAILaning:OnEntityKilled( event )
	local hEntVictim = nil
	local hEntAttacker = nil
	if event.entindex_killed == nil or event.entindex_attacker == nil or self.me == nil then
		return
	end

	hEntVictim = EntIndexToHScript( event.entindex_killed )
	hEntAttacker = EntIndexToHScript( event.entindex_attacker )

	if hEntVictim and hEntVictim:IsCreep() and hEntAttacker:IsHero() then
		print( "Last Hit Score ( Player | AI )" )
		print( "LH: " .. PlayerResource:GetLastHits( 0 ), " | " .. PlayerResource:GetLastHits( self.me:GetPlayerID() ) )
		print( "DN: " .. PlayerResource:GetDenies( 0 ), " | " .. PlayerResource:GetDenies( self.me:GetPlayerID() ) )

		if hEntVictim == self.hActionTarget then
			self.hActionTarget = nil
		end
	end
end

--------------------------------------------------------------------------------
-- nommed_tree
-- > PlayerID - short
--------------------------------------------------------------------------------
function CDotaAILaning:OnNommedTree( event )
	if event.PlayerID == nil then
		return
	end

	if self.me and event.PlayerID == self.me:GetPlayerID() then
		self:InvalidateCurrentAction()
	end
end

--------------------------------------------------------------------------------
-- dota_player_gained_level
-- > PlayerID - short
-- > level - short
-- > hero_entindex - short
--------------------------------------------------------------------------------
function CDotaAILaning:OnPlayerGainedLevel( event )
	if self.me and event.hero_entindex == self.me:entindex() then
		local szAbilityToLearnName = self.AbilityLearnOrder[ event.level ]
		if szAbilityToLearnName == nil then
			print( "Nil ability name in Laning AI learn order!" )
			return
		end

		local hAbilityToLearn = self.me:FindAbilityByName( szAbilityToLearnName )
		if hAbilityToLearn == nil then
			print( "Ability " .. szAbilityToLearnName .. " not found!" )
			return
		end

		hAbilityToLearn:UpgradeAbility( true )
	end
end

-----------------------------------------------------------------------------
-- dota_player_used_ability
-- > PlayerID - short
-- > abilityname - short
--------------------------------------------------------------------------------
function CDotaAILaning:OnPlayerUsedAbility( event )
	if event.PlayerID == nil then
		return
	end

	if self.me and event.PlayerID == self.me:GetPlayerID() and event.abilityname == self.szCurrentAbilityName then
		self:InvalidateCurrentAction()
	end
end

--------------------------------------------------------------------------------

function CDotaAILaning:OnScenarioRestarted( event )
	self.me = nil
end

return CDotaAILaning

