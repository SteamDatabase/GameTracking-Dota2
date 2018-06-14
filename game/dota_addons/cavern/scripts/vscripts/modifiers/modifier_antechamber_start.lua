
modifier_antechamber_start = class({})

--------------------------------------------------------------------------------

function modifier_antechamber_start:GetAbilityTextureName()
	return "silencer_last_word" -- doesn't work
end

--------------------------------------------------------------------------------

function modifier_antechamber_start:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_antechamber_start:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.25 )
	end
end

--------------------------------------------------------------------------------

function modifier_antechamber_start:CheckState()
	local state = {}

	state[ MODIFIER_STATE_SILENCED ] = true
	
	return state
end

--------------------------------------------------------------------------------

function modifier_antechamber_start:OnIntervalThink()
	if IsServer() then
		if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
