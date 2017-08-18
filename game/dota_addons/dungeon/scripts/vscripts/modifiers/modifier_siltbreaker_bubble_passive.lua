
modifier_siltbreaker_bubble_passive = class({})

----------------------------------------------------------------------------------

function modifier_siltbreaker_bubble_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_siltbreaker_bubble_passive:OnCreated( kv )
	if IsServer() then
		self.hOwner = self:GetParent():GetOwnerEntity()

		self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )
		self:GetParent():AddNewModifier( nil, nil, "modifier_magic_immune", { duration = -1 } )

		if self.hOwner then
			local vPos = self.hOwner:GetOrigin() + Vector( 0, 150, 0 )
			self.nFXIndex = ParticleManager:CreateParticle( "particles/act_2/siltbreaker_bubble.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hOwner )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self.hOwner, PATTACH_ABSORIGIN_FOLLOW, nil, vPos, true )
			ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 1.5, 1.5, 1.5 ) ) -- target model scale

			EmitSoundOn( "Siltbreaker.Bubble.Drowning", self:GetParent() )
		else
			self:Destroy()
			return
		end
	end
end

----------------------------------------------------------------------------------

function modifier_siltbreaker_bubble_passive:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_STUNNED]  = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_DISARMED] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_BLIND ] = true
		state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
	end

	return state
end

-----------------------------------------------------------------------

function modifier_siltbreaker_bubble_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_siltbreaker_bubble_passive:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			ParticleManager:DestroyParticle( self.nFXIndex, false )

			StopSoundOn( "Siltbreaker.Bubble.Drowning", self:GetParent() )
			EmitSoundOn( "Siltbreaker.Bubble.Killed", self:GetParent() )

			if self.hOwner and self.hOwner:HasModifier( "modifier_siltbreaker_bubble" ) then
				self.hOwner:RemoveModifierByName( "modifier_siltbreaker_bubble" )
			end
		end
	end

	return 0 
end

-----------------------------------------------------------------------

