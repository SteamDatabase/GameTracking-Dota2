modifier_disruptor_glimpse_thinker_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_thinker_nb2017:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_thinker_nb2017:IsPurgable()
	return true;
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_thinker_nb2017:OnCreated( kv )
	if IsServer() then
		self.hGlimpsedUnits = {}
		self.vStartLocations = {}
	end
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_thinker_nb2017:AddGlimpsedUnit( hUnit, vOldLocation )
	if IsServer() then
		if hUnit ~= nil then
			table.insert( self.hGlimpsedUnits, hUnit )
			table.insert( self.vStartLocations, vOldLocation )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_thinker_nb2017:OnIntervalThink()
	if IsServer() then
		if #self.hGlimpsedUnits == 0 then
			StopSoundEvent( "Hero_Disruptor.GlimpseNB2017.Destination", nil )
			UTIL_Remove( self:GetParent() )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_thinker_nb2017:BeginGlimpse()
	if IsServer() then
		self:StartIntervalThink( 1.0 )

		local count = #self.hGlimpsedUnits
		--print ( "Glimpse loop has ")
		--print ( count )
		for i = 1,count do
			local hUnit = self.hGlimpsedUnits[i]
			local vOldLocation = self.vStartLocations[i]
			if hUnit ~= nil and vOldLocation ~= nil then
				local vVelocity = ( vOldLocation - hUnit:GetOrigin() )
				vVelocity.z = 0.0

				local flDist = vVelocity:Length2D()
				vVelocity = vVelocity:Normalized()

				local flDuration = math.max( 0.05, math.min( 1.8, flDist / 600.0 ) )
				if flDuration > 0.25 then
					local projectile =
					{
						EffectName = nil,
						Ability = self:GetAbility(),
						Source = self:GetCaster(),

						vSpawnOrigin = hUnit:GetOrigin(), 
						vVelocity = vVelocity * ( flDist / flDuration ),
						fDistance = flDist,
						
						bProvidesVision = true,
						iVisionRadius = 400,
						iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
					}

					--ProjectileManager:CreateLinearProjectile( info )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex, 1, vOldLocation )
					ParticleManager:SetParticleControl( nFXIndex, 2, Vector( flDuration, flDuration, flDuration ) )
					self:AddParticle( nFXIndex, false, false, -1, false, false )
	
					local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex2, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex2, 1, vOldLocation )
					ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( flDuration, flDuration, flDuration ) )
					self:AddParticle( nFXIndex2, false, false, -1, false, false )

					local nFXIndex3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex3, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex3, 2, Vector( flDuration, flDuration, flDuration ) )
					self:AddParticle( nFXIndex3, false, false, -1, false, false )
					
					EmitSoundOnLocationForAllies( vOldLocation, "Hero_Disruptor.GlimpseNB2017.Destination", self:GetCaster() )
					local buff = hUnit:FindModifierByName( "modifier_disruptor_glimpse_nb2017" )
					if buff ~= nil then
						buff.hThinker = self
						--print( "Setting expire time for " )
						--print( i )
						buff:SetExpireTime( GameRules:GetGameTime() + flDuration )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_thinker_nb2017:EndGlimpse( hUnit )
	--print ( "Entering EndGlimpse" )
	if hUnit ~= nil and not hUnit:IsMagicImmune() then
		for i = 1,#self.hGlimpsedUnits do
			local unit = self.hGlimpsedUnits[i]
			if unit == hUnit then
			--	print ( "Ending glimpse ")
			--	print ( i )
				FindClearSpaceForUnit( hUnit, self.vStartLocations[i], true )
				hUnit:Interrupt()
				StopSoundOn( "Hero_Disruptor.GlimpseNB2017.Target", hUnit )
		    	table.remove( self.hGlimpsedUnits, i )
		    	table.remove( self.vStartLocations, i )
		    --	print( "Glimpse thinker has units left:" )
		    --	print ( #self.hGlimpsedUnits )

				local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_disruptor_glimpse_arrival_damage" )
				if hTalent and hTalent:GetLevel() > 0 then
					local damage =
					{
						victim = hUnit,
						attacker = self:GetCaster(),
						ability = self:GetAbility(),
						damage = hTalent:GetSpecialValueFor( "value" ),
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					ApplyDamage( damage )
				end
		    end
		 end
	end
end

--------------------------------------------------------------------------------

function modifier_disruptor_glimpse_thinker_nb2017:RemoveUnit( hUnit )
	for i = 1,#self.hGlimpsedUnits do
		local unit = self.hGlimpsedUnits[i]
		if unit == hUnit then
		--	print( "Unit died, removing")
		--	print( i )
			table.remove( self.hGlimpsedUnits, i )
			table.remove( self.vStartLocations, i )
		end
	end
end