
if modifier_boss_arc_warden_shard_counter == nil then
	modifier_boss_arc_warden_shard_counter = class({})
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_shard_counter:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_shard_counter:IsPurgable()
	return false
end


--------------------------------------------------------------------------------

function modifier_boss_arc_warden_shard_counter:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_shard_counter:GetOverrideAnimation( params )
	return ACT_DOTA_TELEPORT
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_shard_counter:OnCreated( kv )
	if IsServer() == false then
		return
	end

	self.fAccumulatedTime = 0.0
	self.time_per_stack = kv.time_per_stack
	self.max_stacks = kv.max_stacks
	self.vMeteorChannelPos = Vector( kv.x, kv.y, kv.z )

	self.nCurrentStacks = 0

	self.nParticleFX = -1
	self.fInterval = 0.033
	self.flNextFXTime = GameRules:GetGameTime()
	self:StartIntervalThink( self.fInterval )

	self.SparkWraithsToSummon = {}
	self.fTimeBetweenSparkWraiths = 0.1
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_shard_counter:OnIntervalThink()
	if IsServer() == false then
		return
	end

	self.fAccumulatedTime = self.fAccumulatedTime + self.fInterval
	local nStacks = ( math.floor( self.fAccumulatedTime / self.time_per_stack ) ) + 1
	if nStacks <= self.max_stacks then
		self:SetStackCount( nStacks )
	end
	
	local nStacks = self:GetStackCount()
	if nStacks ~= self.nCurrentStacks then
		self.nCurrentStacks = nStacks
		EmitSoundOn( 'ArcWardenBoss.CompassPowerUp', self:GetParent() )
	end

	if nStacks > 0 then
		local nStack = math.mod( nStacks, 10 )
		local nTensStack = math.floor( nStacks / 10 ) 
		if self.nParticleFX == -1 then
			self.nParticleFX = ParticleManager:CreateParticle( "particles/arc_warden_boss/nemestice_meteor_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		end
		ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )
		ParticleManager:SetParticleControl( self.nParticleFX, 3, Vector( 0.8, 0.5, 0.8 ) )
	end

	if GameRules:GetGameTime() > self.flNextFXTime then
		self.flNextFXTime = self.flNextFXTime + 0.5
		
		-- Particle
		if self.hMeteor ~= nil then
			local nFXIndex = ParticleManager:CreateParticle( "particles/arc_warden_boss/meteor_channel.vpcf", PATTACH_CUSTOMORIGIN, self.hMeteor )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, self.vMeteorChannelPos ) 
			ParticleManager:SetParticleControl( nFXIndex, 5, Vector( 0.5 * 2, 0, 0 ) ) 
			--ParticleManager:SetParticleFoWProperties( nFXIndex, 0, 1, 50.f )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			print( 'ERROR! self.hMeteor is nil for modifier_boss_arc_warden_shard_counter!' )
		end
	end

	--[[if #self.SparkWraithsToSummon > 0 and GameRules:GetGameTime() > self.fNextSparkWraithSummonTime then
		self.fNextSparkWraithSummonTime = self.fNextSparkWraithSummonTime + self.fTimeBetweenSparkWraiths

		local vPos = self.SparkWraithsToSummon[1]
		CreateModifierThinker( self.hBoss, self.hSparkWraithAbility, "modifier_aghsfort_arc_warden_boss_spark_wraith_thinker", self.SparkWraithKV, vPos, self.hBoss:GetTeamNumber(), false )
		table.remove( self.SparkWraithsToSummon, 1 )
	end--]]
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_shard_counter:CreateSparkWraithMaze( SummonTable, kv, hBoss, hAbility )
	self.fNextSparkWraithSummonTime = GameRules:GetGameTime()
	self.SparkWraiths = {}

	self.SparkWraithsToSummon = SummonTable
	self.hBoss = hBoss
	self.SparkWraithKV = kv
	self.hSparkWraithAbility = hAbility
end

--------------------------------------------------------------------------------

function modifier_boss_arc_warden_shard_counter:OnDestroy()
	if IsServer() == false then
		return
	end

	if self.nParticleFX ~= -1 then
		ParticleManager:DestroyParticle( self.nParticleFX, true )
		self.nParticleFX = -1
	end
end

