
modifier_holdout_tower = class({})

--------------------------------------------------------------------------------

function modifier_holdout_tower:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_holdout_tower:OnCreated( kv )
	if IsServer() then
		self:GetParent().bHasPlayedDmgAnim = false
	end
end

--------------------------------------------------------------------------------

function modifier_holdout_tower:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_holdout_tower:OnTakeDamage( params )
	if IsServer() then
		local hUnit = params.unit
		if hUnit ~= self:GetParent() then
			return
		end

		if hUnit.bHasPlayedDmgAnim == false and hUnit:GetHealthPercent() < 50 then
			self:GetParent():StartGesture( ACT_DOTA_DIE )
			hUnit.bHasPlayedDmgAnim = true
			self:StartIntervalThink( 3.0 )
		end
	end
end

-----------------------------------------------------------------------

function modifier_holdout_tower:OnIntervalThink()
	if IsServer() then
		if not self:GetParent().bHasPlayedStaticDmgAnim then
			self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_1 )
			self:GetParent().bHasPlayedStaticDmgAnim = true
			self:StartIntervalThink( -1 )
		end
	end
end

-----------------------------------------------------------------------

