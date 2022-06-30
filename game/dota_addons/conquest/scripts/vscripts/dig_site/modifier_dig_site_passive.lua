-- Dig Site Passive Modifier - Handles refreshing dig sites, damage immunity, vision

if modifier_dig_site_passive == nil then
	modifier_dig_site_passive = class({})
end

--------------------------------------------------------------------------------

function modifier_dig_site_passive:IsHidden()
	return true
end


--------------------------------------------------------------------------------

function modifier_dig_site_passive:OnCreated( kv )
	if IsServer() then
        self.flNextRefreshTime = 120.0
		self.flNextParticleTime = 3.0
		self:StartIntervalThink( 0.1 )

		self.flActiveHeight = self:GetCaster():GetAbsOrigin().z
		self.flInactiveHeight = self.flActiveHeight - 250
		self.lerpAlpha = 0
		
		self.bNeedsApplyMotion = true
		self.bInMotion = false

        kv = {}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_dig_site_cooldown", kv)
	end
end

--------------------------------------------------------------------------------

function modifier_dig_site_passive:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_dig_site_passive:OnIntervalThink()
	if IsServer() then
		if self.bNeedsApplyMotion and self.bInMotion == false then
			self.bNeedsApplyMotion = false
			if self:ApplyVerticalMotionController() == false then 
				print("ERROR: Couldn't apply vertical motion controller")
			end
			self.bInMotion = true
		end

		local time = GameRules:GetDOTATime(false, false)
        if time >= self.flNextRefreshTime then
            self.flNextRefreshTime = self.flNextRefreshTime + 60.0

			local hDigSiteCooldown = self:GetCaster():FindModifierByName( "modifier_dig_site_cooldown" )
            if hDigSiteCooldown ~= nil then
                MinimapEvent( DOTA_TEAM_GOODGUYS, self:GetCaster(), self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5.0 )
                MinimapEvent( DOTA_TEAM_BADGUYS, self:GetCaster(), self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5.0 )
            end

            self:GetCaster():RemoveModifierByName( "modifier_dig_site_cooldown" )
            print("Dig Sites refreshed")
        end

		if time >= self.flNextParticleTime then
			local fx = ParticleManager:CreateParticle( "particles/econ/events/ti9/shovel_revealed_loot_variant_0_treasure_glow.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( fx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false )
			self:GetParent():Attribute_SetIntValue( "effectsID", fx )
			self.flNextParticleTime = self.flNextParticleTime + 3.5
		end
	end
end

--------------------------------------------------------------------------------

function modifier_dig_site_passive:UpdateVerticalMotion( me, dt )
	if IsServer() then
		local move_time = 2.0
		local delay = 1.0
		local max_alpha = 1.0 + delay / move_time
		local delta = dt / move_time

		local hDigSiteCooldown = self:GetCaster():FindModifierByName( "modifier_dig_site_cooldown" )
		if hDigSiteCooldown ~= nil then
			self.lerpAlpha = self.lerpAlpha - delta
			if self.lerpAlpha < 0 then self.lerpAlpha = 0 end
		else
			self.lerpAlpha = self.lerpAlpha + delta
			if self.lerpAlpha > max_alpha then self.lerpAlpha = max_alpha end
		end

		local alpha = self.lerpAlpha
		if alpha > 1 then alpha = 1 end
		if alpha < 0 then alpha = 0 end 

		local current = self:GetCaster():GetAbsOrigin();

		local vNewZ = Lerp(alpha, self.flInactiveHeight, self.flActiveHeight)
		current.z = vNewZ

		me:SetOrigin( current )
	end
end

--------------------------------------------------------------------------------

function modifier_dig_site_passive:CheckState()
	local state = 
	{
		[MODIFIER_STATE_PROVIDES_VISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_dig_site_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_dig_site_passive:GetModifierProvidesFOWVision( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_dig_site_passive:GetAbsoluteNoDamagePhysical( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_dig_site_passive:GetAbsoluteNoDamageMagical( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_dig_site_passive:GetAbsoluteNoDamagePure( params )
	return 1
end

-----------------------------------------------------------------------


