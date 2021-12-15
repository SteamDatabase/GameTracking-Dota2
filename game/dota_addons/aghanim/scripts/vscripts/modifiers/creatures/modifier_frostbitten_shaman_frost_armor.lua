
modifier_frostbitten_shaman_frost_armor = class({})

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-----------------------------------------------------------------------------

--[[
function modifier_frostbitten_shaman_frost_armor:GetEffectName()
	return "particles/act_2/frostbitten_shaman_repel_buff.vpcf"
end
]]

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor:GetStatusEffectName()  
	return "particles/status_fx/status_effect_frost_armor.vpcf"
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor:OnCreated( kv )
	if not self:GetAbility() then
		return
	end

	if IsServer() then
		self.debuff_duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_frost_armor.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150, 150, 150 ) )
		--ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, vPos, true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )

		EmitSoundOn( "FrostbittenShaman.FrostArmor.Buff", self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor:OnAttacked( params )
	if IsServer() then
		local hVictim = params.target
		if hVictim ~= self:GetParent() then
			return
		end

		local hAttacker = params.attacker
		if hAttacker and ( hAttacker:IsMagicImmune() == false ) then
			if hVictim and hAttacker:IsTower() == false and hVictim:GetTeamNumber() ~= hAttacker:GetTeamNumber() then
				hAttacker:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_frostbitten_shaman_frost_armor_debuff", { duration = self.debuff_duration } )
			end
		end
	end
end

-----------------------------------------------------------------------------

