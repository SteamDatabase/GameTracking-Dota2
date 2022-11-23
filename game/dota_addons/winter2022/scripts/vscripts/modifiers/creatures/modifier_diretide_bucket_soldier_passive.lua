if modifier_diretide_bucket_soldier_passive == nil then
	modifier_diretide_bucket_soldier_passive = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------------

--function modifier_diretide_bucket_soldier_passive:GetEffectName()
--	return "particles/units/creatures/bucket_guardian/bucket_guardian_ambient.vpcf"
--end

function modifier_diretide_bucket_soldier_passive:OnCreated( kv )
	self.attackers = {}
end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs
end

----------------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:CheckState()
	if IsServer() == false then
		return
	end

	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:OnAttackLanded( params )
	if IsServer() == false then
		return
	end

	local hAttacker = params.attacker
	if ( hAttacker == nil ) or hAttacker:IsNull() or ( hAttacker ~= self:GetParent() ) then
		return
	end

	local hVictim = params.target
	if hVictim == nil or hVictim:IsNull() then
		return
	end

	-- kill illusions
	if hVictim:IsIllusion() and not hVictim:IsStrongIllusion() then
		hVictim:Kill( self:GetAbility(), self:GetCaster() )
		return
	end

	-- kill wards
	if hVictim:IsWard() or hVictim:IsHeroWard() then
		hVictim:Kill( self:GetAbility(), self:GetCaster() )
		return
	end
end

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_passive:GetModifierProvidesFOWVision( params )
	if params.target ~= nil and ( params.target:GetTeamNumber() == DOTA_TEAM_GOODGUYS or params.target:GetTeamNumber() == DOTA_TEAM_BADGUYS or params.target:GetTeamNumber() == DOTA_TEAM_CUSTOM_1 ) then
		return 1
	end
	return 0
end

--------------------------------------------------------------------------------
function modifier_diretide_bucket_soldier_passive:OnTakeDamage( params )
	if IsServer() and self:GetParent() == params.unit then
		local hAttacker = params.attacker
		if hAttacker ~= nil and not hAttacker:IsNull() and hAttacker:IsOwnedByAnyPlayer() and hAttacker:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			self.attackers[hAttacker:GetPlayerOwnerID()] = GameRules:GetDOTATime(false, true)
		end
	end
end

--------------------------------------------------------------------------------
function modifier_diretide_bucket_soldier_passive:OnDeath( params )
	if IsServer() and self:GetParent() == params.unit then
		-- ensure the well didn't just die and kill bucket soldier
		if params.attacker ~= nil then
			local fTime = GameRules:GetDOTATime(false, true)
			local rewardedPlayers = {}
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				-- only reward assists for attackers in last 20 seconds. Matches hero assist timing in c++
				if self.attackers[nPlayerID] ~= nil and self.attackers[nPlayerID] > fTime - 20.0 then
					if rewardedPlayers[nPlayerID] == nil then
						GameRules.Winter2022:GrantEventAction( nPlayerID, "winter2022_kill_bucket_soldier", 1 )
						rewardedPlayers[nPlayerID] = true
					end
				end
			end
		end
	end
end