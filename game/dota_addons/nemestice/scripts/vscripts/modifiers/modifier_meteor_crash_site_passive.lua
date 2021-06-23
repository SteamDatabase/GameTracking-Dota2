if modifier_meteor_crash_site_passive == nil then
	modifier_meteor_crash_site_passive = class({})
end

--------------------------------------------------------------------------------

function modifier_meteor_crash_site_passive:IsHidden()
	return true
end


--------------------------------------------------------------------------------

function modifier_meteor_crash_site_passive:OnCreated( kv )
	if IsServer() then
		self.flNextPingTime = GameRules:GetGameTime() + 10.0
		self:StartIntervalThink( 0.1 )
		--self.nGoodViewer = AddFOWViewer( DOTA_TEAM_GOODGUYS, self:GetCaster():GetAbsOrigin(), 700, 99999, true )
		--self.nBadViewer = AddFOWViewer( DOTA_TEAM_BADGUYS, self:GetCaster():GetAbsOrigin(), 700, 99999, true )

		self.nParticleFX = ParticleManager:CreateParticle( "particles/gameplay/moon_juice_overhead/moon_juice_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nParticleFX, 3, Vector( NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_R, NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_G, NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_B ) )
		
		self:UpdateOverheadParticles()
	end
end

--------------------------------------------------------------------------------

function modifier_meteor_crash_site_passive:UpdateOverheadParticles()
	local hShardPouch = self:GetCaster():FindAbilityByName( "hero_meteor_shard_pouch" )
	if hShardPouch then
		local nCharges = hShardPouch:GetShardCount()
		local nStack = math.mod( nCharges, 10 )
		local nTensStack = math.floor( nCharges / 10 )
		ParticleManager:SetParticleControl( self.nParticleFX, 2, Vector( nTensStack, nStack, 0 ) )
	end
end

--------------------------------------------------------------------------------

function modifier_meteor_crash_site_passive:OnIntervalThink()
	if IsServer() then
		
		self:UpdateOverheadParticles()

		local hShardPouch = self:GetCaster():FindAbilityByName( "hero_meteor_shard_pouch" )
		if hShardPouch and hShardPouch:GetShardCount() <= 0 then
			local nFXIndex = ParticleManager:CreateParticle( "particles/radiant_fx/radiant_melee_barracks001_destruction.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "Building_Generic.Destruction", self:GetCaster() )

			self:GetCaster():ForceKill( false )
			self:GetCaster():AddEffects( EF_NODRAW )
			self:StartIntervalThink( -1 )

			-- if self.nGoodViewer ~= nil then
			-- 	RemoveFOWViewer( DOTA_TEAM_GOODGUYS, self.nGoodViewer )
			-- 	self.nGoodViewer = nil
			-- end

			-- if self.nBadViewer ~= nil then
			-- 	RemoveFOWViewer( DOTA_TEAM_BADGUYS, self.nBadViewer )
			-- 	self.nBadViewer = nil
			-- end
		else
			if GameRules:GetGameTime() > self.flNextPingTime then
				self.flNextPingTime = GameRules:GetGameTime() + 10.0
				--MinimapEvent( DOTA_TEAM_GOODGUYS, self:GetCaster(), self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5.0 )
				--MinimapEvent( DOTA_TEAM_BADGUYS, self:GetCaster(), self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5.0 )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_meteor_crash_site_passive:CheckState()
	local state = {}
	if IsServer()  then
		
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_meteor_crash_site_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_meteor_crash_site_passive:GetModifierProvidesFOWVision( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_meteor_crash_site_passive:GetAbsoluteNoDamagePhysical( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_meteor_crash_site_passive:GetAbsoluteNoDamageMagical( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_meteor_crash_site_passive:GetAbsoluteNoDamagePure( params )
	return 1
end

-----------------------------------------------------------------------


