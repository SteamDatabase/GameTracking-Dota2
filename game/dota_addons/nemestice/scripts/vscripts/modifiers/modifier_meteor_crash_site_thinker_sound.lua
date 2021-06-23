
if modifier_meteor_crash_site_thinker_sound == nil then
	modifier_meteor_crash_site_thinker_sound = class( {} )
end

-----------------------------------------------------------------------------

function modifier_meteor_crash_site_thinker_sound:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_meteor_crash_site_thinker_sound:OnCreated( kv )
	if IsServer() == false then
		return
	end

	self.bPlayedFirst = false
	self.flLengthPowerup = 1.75
	self.flLengthPulse = 9.0

	self:StartIntervalThink( self:GetRemainingTime() - self.flLengthPowerup - self.flLengthPulse )
end


-----------------------------------------------------------------------------

function modifier_meteor_crash_site_thinker_sound:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self.bPlayedFirst == false then
		EmitSoundOn( "Nemestice.CompassPowerUp", self:GetParent() )
		self:StartIntervalThink( self:GetRemainingTime() - self.flLengthPulse )
		self.bPlayedFirst = true
		return
	end

	EmitSoundOn( "Nemestice.CompassPulse", self:GetParent() )

	self:StartIntervalThink( -1 )
end

