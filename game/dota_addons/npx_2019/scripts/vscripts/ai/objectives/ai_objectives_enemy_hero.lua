
-----------------------------------------------------------------------------------------------------

if CObjectivesEnemyHeroBot == nil then
	CObjectivesEnemyHeroBot = class({})
end

-----------------------------------------------------------------------------------------------------

function CObjectivesEnemyHeroBot:constructor( me )
	self.me = me
	self.hAttackTarget = nil
	self.hCastingAbility = nil
end

function CObjectivesEnemyHeroBot:BotThink()
	
	-- If we're in the middle of casting an ability, just let that go
	if self.hCastingAbility then
		
		if self.hCastingAbility:IsCastingAbility() then
			return
		end

		-- Finished the cast, so clear out our state and continue
		self.hCastingAbility = nil
	end

	-- Is the thing we're trying to attack dead? If so clear our attack target
	if self.hAttackTarget and not self.hAttackTarget:IsAlive() then
		self.hAttackTarget = nil
	end

	-- If we have a valid target, see what we shoudl be doing
	if self.hAttackTarget then

		local vSelfPosition = self.me:GetAbsOrigin()
		local vTargetPosition = self.hAttackTarget:GetAbsOrigin()
		local fDistance = ( vTargetPosition - vSelfPosition ):Length2D()

		local fAttackRange = self.me:GetAttackRange()
		if self.me:IsRangedAttacker() then
			fAttackRange = fAttackRange - 100
		end

		-- Are we in range?
		if fDistance > fAttackRange then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
				TargetIndex = self.hAttackTarget:entindex()
			} )
			return
		end

		-- Is this Roshan, so we need to be within the trigger volume?
		if self.hAttackTarget:IsBoss() and not self.me:CanAttackBoss() then
			ExecuteOrderFromTable( {
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
				TargetIndex = self.hAttackTarget:entindex()
			} )
			return
		end

		-- We're in range, so check whether we should cast any abilities
		local hCastAbility = self:ConsiderUsingAbilitiesOnAttackTarget()
		if hCastAbility then
			self.hCastingAbility = hCastAbility
			return
		end

		-- Just attack 
		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.hAttackTarget:entindex()
		} )
		return

	end

end

function CObjectivesEnemyHeroBot:SetAttackTarget( hTarget )
	self.hAttackTarget = hTarget
end

function CObjectivesEnemyHeroBot:ConsiderUsingAbilitiesOnAttackTarget()
	-- subclasses will override this to pick an ability, cast it, and return it
	return nil
end


