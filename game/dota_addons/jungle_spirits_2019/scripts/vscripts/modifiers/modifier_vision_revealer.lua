
modifier_vision_revealer = class({})

----------------------------------------------------------------------------------

function modifier_vision_revealer:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_vision_revealer:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_vision_revealer:OnCreated( kv )
	if IsServer() then
		self.fTimeCreated = GameRules:GetGameTime()
		self.fFXExpireTime = self.fTimeCreated + GEM_SPAWN_WARNING_TIME

		-- Timer
		local fTimer = GEM_SPAWN_WARNING_TIME
		local nRadius = 400
		local vOverheadPos = self:GetParent():GetAbsOrigin() + Vector( 0, 0, 100 )

		self.nTimerFX = ParticleManager:CreateParticle( "particles/essence_treasure_timer.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.nTimerFX, 1, Vector( math.floor( fTimer ), 0, 0 ) )
		ParticleManager:SetParticleControl( self.nTimerFX, 2, Vector( nRadius, 0, - nRadius / fTimer ) )

		EmitSoundOnLocationForAllies( self:GetParent():GetAbsOrigin(), "Gem.Spawn_Warning", self:GetParent() )

		self:StartIntervalThink( 0.0 )
	end
end

----------------------------------------------------------------------------------

function modifier_vision_revealer:OnIntervalThink()
	if IsServer() then
		--printf( "gemdrop will spawn in %.2f seconds", ( self.fFXExpireTime - GameRules:GetGameTime() ) )

		if GameRules:GetGameTime() >= self.fFXExpireTime then
			ParticleManager:DestroyParticle( self.nTimerFX, false )

			local modeContext = GameRules.JungleSpirits
			print( "Creating gem for NextGemTime: ", ConvertToTime( modeContext._fNextGemTime ) )
			modeContext:SpawnGem()

			self:StartIntervalThink( -1 )
			return
		end

		self:StartIntervalThink( 1.0 )
	end
end

-----------------------------------------------------------------------

function modifier_vision_revealer:CheckState()
	local state =
	{
		[ MODIFIER_STATE_PROVIDES_VISION ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
		[ MODIFIER_STATE_OUT_OF_GAME ] = true,
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_vision_revealer:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_vision_revealer:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:Destroy()
		end
	end
end

-----------------------------------------------------------------------

function modifier_vision_revealer:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
