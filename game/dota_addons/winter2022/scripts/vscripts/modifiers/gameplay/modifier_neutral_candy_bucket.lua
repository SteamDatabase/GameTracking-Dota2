
if modifier_neutral_candy_bucket == nil then
	modifier_neutral_candy_bucket = class({})
end

------------------------------------------------------------------------------

function modifier_neutral_candy_bucket:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_neutral_candy_bucket:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_neutral_candy_bucket:OnCreated( kv )
	if IsServer() == true then
		self.fMinFlinchRepeatTime = 0.5
		self.fMinFXRepeatTime = 0.1
	end
end

--------------------------------------------------------------------------------

function modifier_neutral_candy_bucket:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_neutral_candy_bucket:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			if self.fLastFlinchTime == nil or ( GameRules:GetDOTATime( false, true ) > ( self.fLastFlinchTime + self.fMinFlinchRepeatTime ) ) then
				self:GetParent():StartGestureWithPlaybackRate( ACT_DOTA_FLINCH, 1.5 )
				self.fLastFlinchTime = GameRules:GetDOTATime( false, true )
			end

			if self.flastFXTime == nil or ( GameRules:GetDOTATime( false, true ) > ( self.flastFXTime + self.fMinFXRepeatTime ) ) then
				self.flastFXTime = GameRules:GetDOTATime( false, true )
				local vPos = self:GetParent():GetAbsOrigin()
				--vPos.z = vPos.z + 80
				local nDamagedFX = ParticleManager:CreateParticle( "particles/scarecrow/scarecrow_damaged.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControl( nDamagedFX, 0, vPos )
				ParticleManager:ReleaseParticleIndex( nDamagedFX )

				EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), "NeutralBucket.Damaged", self:GetParent() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_neutral_candy_bucket:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:GetParent():StartGesture( ACT_DOTA_DIE )
			EmitGlobalSound( "NeutralBucket.Destroyed" )
		end
	end
end

-----------------------------------------------------------------------------------------
