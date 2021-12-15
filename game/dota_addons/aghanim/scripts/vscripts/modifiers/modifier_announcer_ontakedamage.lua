modifier_announcer_ontakedamage = class({})

--------------------------------------------------------------------------------

function modifier_announcer_ontakedamage:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_announcer_ontakedamage:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_announcer_ontakedamage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_announcer_ontakedamage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_announcer_ontakedamage:OnTakeDamage( params )
	if IsServer() then

		local hAnnouncer = GameRules.Aghanim:GetAnnouncer()
		if hAnnouncer == nil then
			return 0
		end

		local flHoldTime = hAnnouncer.flHoldEncourageTime
		local flTime = GameRules:GetGameTime()
		if flHoldTime < flTime then
			return 0
		end

		local hUnit = params.unit
		if hUnit == nil or hUnit:IsNull() then
			return 0
		end

		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsNull() or hAttacker:GetTeamNumber() == hUnit:GetTeamNumber() then
			return 0
		end
		
		local flNewHold = flTime + _G.ANNOUNCER_HOLD_ENCOURAGE_LINE_DAMAGE
		if flNewHold < flHoldTime then
			hAnnouncer.flHoldEncourageTime = flNewHold
		end
	end

	return 0
end
