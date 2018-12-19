modifier_creature_doomling_doom_passive = class({})

--------------------------------------------------------------------------------

function modifier_creature_doomling_doom_passive:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_doomling_doom_passive:IsHidden()
	return false;
end

--------------------------------------------------------------------------------
function modifier_creature_doomling_doom_passive:DeclareFunctions()
	local funcs = {
		--MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_creature_doomling_doom_passive:OnCreated( kv )
	if IsServer() then
	end
end

--------------------------------------------------------------------------------
--function modifier_creature_doomling_doom_passive:OnAttackLanded( params )
function modifier_creature_doomling_doom_passive:OnDeath( params )
	if IsServer() then

		local hAttacker = params.attacker
		
		if params.unit ~= self:GetParent() or not hAttacker then
			return 0
		end

		local flDuration = 5
		local nDoomStackCount = 10

		local hImpendingDoom = hAttacker:FindModifierByName("modifier_impending_doom")
		hRealDoom = hAttacker:FindModifierByName("modifier_doom_bringer_doom") 
		if hImpendingDoom == nil and hRealDoom == nil then
			hImpendingDoom = hAttacker:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_impending_doom", { duration=flDuration} )
		end

		if hImpendingDoom and hRealDoom == nil then
			if hImpendingDoom:GetStackCount() < nDoomStackCount then
				hImpendingDoom:IncrementStackCount()
			end
			hImpendingDoom:ForceRefresh()
		end

	end
	return 0
end