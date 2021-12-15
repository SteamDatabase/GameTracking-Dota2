
modifier_bloodbound_bloodbag = class({})

--------------------------------------------------------------------------------

function modifier_bloodbound_bloodbag:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bloodbound_bloodbag:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bloodbound_bloodbag:OnCreated( kv )
	self.travel_speed = self:GetAbility():GetSpecialValueFor( "travel_speed" )

	if IsServer() then
		local hBloodseeker = self:GetCaster()

		if hBloodseeker ~= nil and hBloodseeker:IsNull() == false and hBloodseeker:IsAlive() then
			local vPos = self:GetParent():GetAbsOrigin()
			vPos.z = 0

			local projInfo =
			{
				Target = hBloodseeker,
				Source = self:GetParent(),
				Ability = self:GetAbility(),
				EffectName = "particles/creatures/bloodseeker/bloodseeker_bloodbag_tracking.vpcf",
				iMoveSpeed = self.travel_speed,
				vSourceLoc = vPos,
				bDodgeable = false,
				bProvidesVision = false,
			}

			local nProjectileHandle = ProjectileManager:CreateTrackingProjectile( projInfo )
			projInfo.nProjectileHandle = nProjectileHandle

			table.insert( self:GetAbility().Projectiles, projInfo )
		end

		self:GetParent():StartGesture( ACT_DOTA_FLAIL )
	end
end

--------------------------------------------------------------------------------

function modifier_bloodbound_bloodbag:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bloodbound_bloodbag:OnDeath( params )
	if IsServer() then
		if params.unit == nil or params.unit:IsNull() then
			return 0
		end

		if params.unit ~= self:GetParent() then
			return 0
		end

		self:GetParent():AddEffects( EF_NODRAW )
	end
end

--------------------------------------------------------------------------------

function modifier_bloodbound_bloodbag:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture( ACT_DOTA_FLAIL )
	end
end

--------------------------------------------------------------------------------
