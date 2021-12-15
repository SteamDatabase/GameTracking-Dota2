modifier_aghslab_phantom_lancer_doppelganger = class({})

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger:CheckState()
	local state = 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	
	return state
end

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger:GetEffectName()
	return "particles/econ/items/phantom_lancer/phantom_lancer_fall20_immortal/phantom_lancer_fall20_immortal_doppelganger_aoe.vpcf"
end

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end


--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger:OnCreated( kv )
	self.num_illusions = self:GetAbility():GetSpecialValueFor( "num_illusions" )
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger:OnDestroy()
	if IsServer() then	
		EmitSoundOn( "Hero_PhantomLancer.Doppelganger.Appear", self:GetParent() )
		
		local vPos = self:GetParent():GetAbsOrigin()

		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vPos, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		local target = enemies[RandomInt(1,#enemies)]

		for i = 1, self.num_illusions do
			local illusion_name = "npc_dota_creature_phantom_lancer_illusion"
			local illusion_origin = vPos
			local illusion = CreateUnitByName(illusion_name, illusion_origin, true, self:GetParent(), nil, DOTA_TEAM_BADGUYS)
		 	illusion:SetInitialGoalEntity( target )
		 end

		self:GetParent():RemoveNoDraw()
	end
end

--------------------------------------------------------------------------------
