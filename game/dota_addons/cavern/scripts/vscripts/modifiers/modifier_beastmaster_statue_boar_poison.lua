
modifier_beastmaster_statue_boar_poison = class({})

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison:OnCreated( kv )
	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	end
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_boar_poison:OnAttacked( params )
	if IsServer() then
		if params.attacker ~= self:GetCaster() then
			return
		end

		local hTarget = params.target

		if hTarget and hTarget:IsTower() == false and hTarget:IsOther() == false and hTarget:IsMagicImmune() == false then
			hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_beastmaster_statue_boar_poison_effect", { duration = self.duration } )
		end
	end
end

--------------------------------------------------------------------------------

