
modifier_item_corrupting_blade = class({})

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.corruption_duration = self:GetAbility():GetSpecialValueFor( "corruption_duration" )
end

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		--MODIFIER_EVENT_ON_ATTACK_FAIL,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end 

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade:OnAttack( params )
	if IsServer() then
		if self:GetParent() ~= params.attacker then
			return 0
		end

		local hTarget = params.target
		local hAttacker = params.attacker

		if hTarget == nil or hAttacker == nil then
			return 0
		end

		if hAttacker:IsIllusion() then
			return 0
		end

		--[[
		CDOTA_AttackRecord *pAttackRecord = GetAttackRecordsManager( )->GetRecordByIndex( params.iRecord );
		pAttackRecord->m_iszAutoAttackRangedParticle = MAKE_STRING( "particles/items_fx/desolator_projectile.vpcf" );
		m_InFlightAttackRecords.AddToTail( pAttackRecord->m_iRecord );
		]]
	end
end 

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() ~= params.attacker then
			return 0
		end
		
		local hTarget = params.target
		local hAttacker = params.attacker

		if hTarget == nil then
			print( "OnAttackLanded - target is nil" )
		end

		if hAttacker == nil then
			print( "OnAttackLanded - attacker is nil" )
		end

		if self:GetAbility() == nil then
			print( "OnAttackLanded - ability is nil" )
		end

		if hTarget == nil or hAttacker == nil or self:GetAbility() == nil then
			return 0
		end

		if hAttacker:IsIllusion() then
			return 0
		end

		hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_item_corrupting_blade_buff", { duration = self.corruption_duration } )

		EmitSoundOn( "Item_Desolator.Target", hTarget )
	end
end 

--------------------------------------------------------------------------------

--[[
function modifier_item_corrupting_blade:OnAttackFail( params )
	
end 
]]

--------------------------------------------------------------------------------

