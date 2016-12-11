if juggernaut_slash == nil then
	juggernaut_slash = class({})
end

function juggernaut_slash:StopSwingGesture()
	if self.nCurrentGesture ~= nil then
		self:GetCaster():RemoveGesture( self.nCurrentGesture )
		self.nCurrentGesture = nil
	end
end

function juggernaut_slash:StartSwingGesture( nAction )
	if self.nCurrentGesture ~= nil then
		self:GetCaster():RemoveGesture( self.nCurrentGesture )
	end
	self.nCurrentGesture = nAction
	self:GetCaster():StartGesture( nAction )
end

function juggernaut_slash:OnAbilityPhaseStart()
	local result = self.BaseClass.OnAbilityPhaseStart( self )
	if result then
		self:StartSwingGesture( ACT_DOTA_ATTACK )
	end
	return result
end

function juggernaut_slash:OnAbilityPhaseInterrupted()
	self:StopSwingGesture()
end

function juggernaut_slash:OnSpellStart()
	local nDamageAmount = self:GetCaster():GetAverageTrueAttackDamage() + self:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
	ApplyDamage( {
		victim = self:GetCursorTarget(),
		attacker = self:GetCaster(),
		damage = nDamageAmount,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self
	} )
end

function juggernaut_slash:GetCastRange( vLocation, hTarget )
	return 128
end
